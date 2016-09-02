namespace Dayslice.Lite {
	public class Application : Gtk.Application {
		public Application () {
			Object(application_id: "skrylar.dayslice.lite",
				   flags: ApplicationFlags.FLAGS_NONE);
		}

		protected override void activate () {
			var appwin = new MainWindow (this);
			appwin.user_notifier = new GLibNotifier ();
			appwin.time_provider = new RealTimeProvider ();
			appwin.show_all ();
		}

		public static int main (string[] args) {
			Application app = new Application ();
			return app.run (args);
		}
	}
} /* Dayslice.Lite */