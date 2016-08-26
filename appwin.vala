namespace Dayslice.Lite {
	[GtkTemplate (ui = "/dayslice/lite/main.ui")]
	public class MainWindow : Gtk.ApplicationWindow {
		// stuff attached to the interface

		[GtkChild]
		internal Gtk.Adjustment timeout_adjustment;

		[GtkChild]
		internal Gtk.Label statuslabel;
		[GtkChild]
		internal Gtk.Label remaining_label;
		[GtkChild]
		internal Gtk.Label expiry_label;

		internal DateTime expiry;

		// handles internal state logic for the timer
		internal FSM state_machine = new FSM ();

		public MainWindow (Gtk.Application owner) {
			GLib.Object (application: owner);
			wire_state_debug ();
			on_entered_idle ();
			Timeout.add_seconds (60, this.on_tick);
		}

		// UI callbacks

		[GtkCallback]
		internal void show_user_help () {
		}

		[GtkCallback]
		internal void start_work () {
			if (timeout_adjustment.value >= 0.1) {
				state_machine.send (FSM.Message.SET_WORK);
			}
		}

		[GtkCallback]
		internal void start_break () {
			if (timeout_adjustment.value >= 0.1) {
				state_machine.send (FSM.Message.SET_BREAK);
			}
		}

		[GtkCallback]
		internal void adjust_timeout () {
			timeout_adjustment.value = (double)Math.llround  (timeout_adjustment.value);
			if (timeout_adjustment.value <= 0.1) {
				state_machine.send (FSM.Message.CANCEL);
			} else {
				var minutes = (int)timeout_adjustment.value * 5;
				state_machine.send (FSM.Message.CHANGE_TIMEOUT);
				expiry = new DateTime.now_local ();
				expiry = expiry.add_minutes (minutes);
				remaining_label.label = "%d minutes".printf (minutes);
				expiry_label.label = expiry.format ("%l:%M %p");
			}
		}

		// state machine debugging

		internal void wire_state_debug () {
			state_machine.entered_idle.connect (on_entered_idle);
			state_machine.entered_set.connect (on_entered_set);
			state_machine.entered_running.connect (on_entered_running);
			state_machine.entered_expired.connect (on_entered_expired);
		}

		// react to state changes

		internal void on_entered_idle () {
			statuslabel.label = "Select a time with the slider above.";
		}

		internal void on_entered_set () {
			statuslabel.label = "Now choose 'work' or 'break.'";
		}

		internal void on_entered_running () {
			statuslabel.label = "";
		}

		internal void on_entered_expired () {
			statuslabel.label = "";
		}

		// handle the passage of time

		internal bool on_tick () {
			// TODO check if we just expired
			return Source.CONTINUE;
		}
	}
} /* Dayslice.Lite */
