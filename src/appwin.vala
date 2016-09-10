namespace Dayslice.Lite {
	[GtkTemplate (ui = "/dayslice/lite/main.ui")]
	public class MainWindow : Gtk.ApplicationWindow {
		// stuff attached to the interface
		public UserNotifier user_notifier { get; set; }

		// provides time through a mockable interface
		public TimeProvider time_provider { get; set; }

		[GtkChild]
		internal Gtk.Adjustment timeout_adjustment;

		[GtkChild]
		internal Gtk.Label statuslabel;
		[GtkChild]
		internal Gtk.Label remaining_label;
		[GtkChild]
		internal Gtk.Label expiry_label;
		[GtkChild]
		internal Gtk.Revealer timer_revealer;
		[GtkChild]
		internal Gtk.Stack buttonstack;
		[GtkChild]
		internal Gtk.ButtonBox idle_buttonbox;
		[GtkChild]
		internal Gtk.ButtonBox running_buttonbox;

		internal DateTime expiry;

		// handles internal state logic for the timer
		internal FSM state_machine = new FSM ();

		public MainWindow (Gtk.Application owner) {
			GLib.Object (application: owner);
			wire_states ();
			on_entered_idle ();
			Timeout.add_seconds (60, this.on_tick);
		}

		// UI callbacks

		[GtkCallback]
		internal void show_user_help () {
		}

		[GtkCallback]
		internal void start () {
			if (timeout_adjustment.value >= 0.1) {
				state_machine.send (FSM.Message.START);
			}
		}

		[GtkCallback]
		internal void cancel () {
			state_machine.send (FSM.Message.CANCEL);
		}

		[GtkCallback]
		internal void adjust_timeout () {
			timeout_adjustment.value = (double)Math.llround (timeout_adjustment.value);
			if (timeout_adjustment.value <= 0.1) {
				state_machine.send (FSM.Message.CANCEL);
			} else {
				var minutes = (int)timeout_adjustment.value * 5;
				expiry = time_provider.now ();
				expiry = expiry.add_minutes (minutes);
				remaining_label.label = "%d minutes".printf (minutes);
				expiry_label.label = expiry.format ("%l:%M %p");
				state_machine.send (FSM.Message.CHANGE_TIMEOUT);
			}
		}

		// state machine debugging

		internal void wire_states () {
			state_machine.entered_idle.connect (on_entered_idle);
			state_machine.exited_idle.connect (on_exited_idle);
			state_machine.entered_set.connect (on_entered_set);
			state_machine.exited_running.connect (on_exited_running);
			state_machine.entered_running.connect (on_entered_running);
			state_machine.entered_expired.connect (on_entered_expired);
		}

		// react to state changes

		internal void on_exited_idle () {
			timer_revealer.reveal_child = true;
		}

		internal void on_entered_idle () {
			statuslabel.label = "Select a time with the slider above.";
			timer_revealer.reveal_child = false;
		}

		internal void on_entered_set () {
			statuslabel.label = "Now press 'Start.'";
		}

		internal void on_exited_running () {
			buttonstack.set_visible_child (idle_buttonbox);
		}

		internal void on_entered_running () {
			statuslabel.label = "";
			buttonstack.set_visible_child (running_buttonbox);
			user_notifier.trigger_started (application);
		}

		internal void on_entered_expired () {
			// NB immediately cancel the expiry state; sends us back
			// to idle. we might do something clever in the future
			// like wait for the user to acknowledge expiry, nag until
			// they acknowledge the end of a slice, or ask if they
			// want to extend the slice, but right now all we do is
			// annoy the user and wait for something to do.
			statuslabel.label = "Time's up.";
			user_notifier.trigger_finished (application);
			timeout_adjustment.value = 0.0;
		}

		// handle the passage of time

		internal bool on_tick () {
			var now = time_provider.now ();
			if (state_machine.state != FSM.State.RUNNING) {
				var minutes = (int)timeout_adjustment.value * 5;
				expiry = now.add_minutes (minutes);
				expiry_label.label = expiry.format ("%l:%M %p");
			} else {
				var diff = expiry.difference (now) / TimeSpan.MINUTE;
				if (diff > 1) {
					// TODO make sure window is on the screen
					remaining_label.label = "%d minutes".printf ((int)diff);
					if (diff % 5 == 0) {
						var value = (diff / 5);
						if (value < 0.1) {
							state_machine.send (FSM.Message.EXPIRE);
						}
						timeout_adjustment.value = (double)value;
					}
				} else {
					state_machine.send (FSM.Message.EXPIRE);
				}
			}

			// TODO check if we just expired
			return Source.CONTINUE;
		}
	}
} /* Dayslice.Lite */
