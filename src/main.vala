/* Copyright (C) 2016 Joshua A. Cearley

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see
   <http://www.gnu.org/licenses/>.
*/

namespace Dayslice.Lite {
	public class Application : Gtk.Application {
		public Application () {
			Object(application_id: "skrylar.dayslice.lite",
				   flags: 0);
		}

		internal MainWindow appwin;

#if ROBOTICIZED
		public RobotOverlord overlord { get; set; }
#endif /* ROBOTICIZED */

		protected override void activate () {
			if (appwin != null) {
				appwin.present ();
				return;
			}

			appwin = new MainWindow (this);
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