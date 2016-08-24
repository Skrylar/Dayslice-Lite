namespace Dayslice.Lite {
	[GtkTemplate (ui = "/dayslice/lite/main.ui")]
	public class MainWindow : Gtk.ApplicationWindow {
		[GtkChild]
		Gtk.Adjustment timeout_adjustment;

		public MainWindow (Gtk.Application owner) {
			GLib.Object (application: owner);
		}

		[GtkCallback]
		internal void show_user_help () {
		}

		[GtkCallback]
		internal void start_work () {
		}

		[GtkCallback]
		internal void start_break () {
		}

		[GtkCallback]
		internal void adjust_timeout () {
			stdout.printf("Time bucket: %f\n", timeout_adjustment.value);
		}
	}
} /* Dayslice.Lite */
