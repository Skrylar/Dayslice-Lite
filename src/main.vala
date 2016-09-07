namespace Dayslice.Lite {
	public class Application : Gtk.Application {
		public Application () {
			Object(application_id: "skrylar.dayslice.lite",
				   flags: ApplicationFlags.FLAGS_NONE);
		}

#if ROBOTICIZED
		public RobotOverlord overlord { get; set; }
#endif /* ROBOTICIZED */

		protected override void activate () {
			var appwin = new MainWindow (this);
#if !ROBOTICIZED
			appwin.user_notifier = new GLibNotifier ();
			appwin.time_provider = new RealTimeProvider ();
#else /* ROBOTICIZED */
			RobotOverlord.main_window = appwin;
			appwin.user_notifier = new MockNotifier ();
			appwin.time_provider = new MockTimeProvider ();
#endif /* ROBOTICIZED */
			appwin.show_all ();
		}

#if ROBOTICIZED
		public static void activate_testing_rig () {
			var app = new Application ();
			try {
				app.register ();
			} catch (GLib.Error e) {
				assert_not_reached ();
			}
			var overlord = new RobotOverlord ();
			RobotOverlord.main_context = new MainContext ();
			app.overlord = overlord;
			RobotOverlord.main_context.acquire ();
			app.activate ();
			RobotOverlord.sync ();
			RobotOverlord.main_context.release ();
		}
#endif /* ROBOTICIZED */

#if !ROBOTICIZED
		public static int main (string[] args) {
			Application app = new Application ();
			return app.run (args);
		}
#endif /* !ROBOTICIZED */
	}
} /* Dayslice.Lite */