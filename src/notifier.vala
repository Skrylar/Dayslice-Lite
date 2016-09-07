namespace Dayslice {
	namespace Lite {
		public interface UserNotifier: GLib.Object {
			// a timer has just started
			public abstract void trigger_started (Gtk.Application app);

			// a timer has just finished
			public abstract void trigger_finished (Gtk.Application app);

			// withdraw messages when necessary
			public abstract void trigger_withdraw (Gtk.Application app);
		}

		// tosses events to stdout; mostly for debugging since i have
		// no idea who is going to use this without a curses
		// interface.
		//
		// NB: a curses interface would be pretty cool.
		public class StdoutNotifier : GLib.Object, UserNotifier {
			public StdoutNotifier () {
			}

			~StdoutNotifier () {}

			public void trigger_started (Gtk.Application app) {
				stdout.printf("Timer has started.\n");
			}

			public void trigger_finished (Gtk.Application app) {
				stdout.printf("Timer has expired.\n");
			}

			public void trigger_withdraw (Gtk.Application app) {}
		}

		public class GLibNotifier : GLib.Object, UserNotifier {
			public GLibNotifier () {
			}

			~GLibNotifier () {}

			public void trigger_started (Gtk.Application app) {
				var notice = new Notification ("Dayslice Lite");
				notice.set_body ("Your timer is now running.");
				notice.set_priority (GLib.NotificationPriority.LOW);
				app.withdraw_notification ("dsl.timer");
				app.send_notification ("dsl.timer", notice);
			}

			public void trigger_finished (Gtk.Application app) {
				var notice = new Notification ("Dayslice Lite");
				notice.set_body ("Timer has expired.");
				notice.set_priority (GLib.NotificationPriority.URGENT);
				app.withdraw_notification ("dsl.timer");
				app.send_notification ("dsl.timer", notice);
			}

			public void trigger_withdraw (Gtk.Application app) {
				app.withdraw_notification ("dsl.timer");
			}
		}

		public class MockNotifier : GLib.Object, UserNotifier {
			public MockNotifier () {
			}

			~MockNotifier () {}

			// used to determine if triggers have been tripped since
			// we last reset them
			protected uint code = 1;
			protected uint code_started = 0;
			protected uint code_finished = 0;

			public void reset () {
				code++;
			}

			public void trigger_started (Gtk.Application app) {
				code_started = code;
			}

			public bool has_started () {
				return code == code_started;
			}

			public void trigger_finished (Gtk.Application app) {
				code_finished = code;
			}

			public bool has_finished () {
				return code == code_finished;
			}

			public void trigger_withdraw (Gtk.Application app) {
			}
		}
	} /* Lite */
} /* Dayslice */