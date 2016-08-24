namespace Dayslice.Lite {
	[GtkTemplate (ui = "/dayslice/lite/main.ui")]
	public class MainWindow : Gtk.ApplicationWindow {
		[GtkChild]
		Gtk.Adjustment timeout_adjustment;

		internal FSM state_machine = new FSM ();

		public MainWindow (Gtk.Application owner) {
			GLib.Object (application: owner);
		}

		[GtkCallback]
		internal void show_user_help () {
		}

		[GtkCallback]
		internal void start_work () {
			state_machine.send (FSM.Message.SET_WORK);
		}

		[GtkCallback]
		internal void start_break () {
			state_machine.send (FSM.Message.SET_BREAK);
		}

		[GtkCallback]
		internal void adjust_timeout () {
			state_machine.send (FSM.Message.CHANGE_TIMEOUT);
		}
	}
} /* Dayslice.Lite */
