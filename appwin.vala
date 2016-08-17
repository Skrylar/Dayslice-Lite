namespace Dayslice.Lite {
	[GtkTemplate (ui = "/dayslice/lite/main.ui")]
	public class MainWindow : Gtk.ApplicationWindow {
		public MainWindow (Gtk.Application owner) {
			GLib.Object (application: owner);
		}
	}
} /* Dayslice.Lite */
