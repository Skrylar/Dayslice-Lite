namespace Dayslice {
	namespace Lite {
		public interface UserNotifier: GLib.Object {
			// a timer has just started
			public abstract void trigger_started ();

			// a timer has just finished
			public abstract void trigger_finished ();
		}

		public class StdoutNotifier : GLib.Object, UserNotifier {
			public StdoutNotifier () {
			}

			~StdoutNotifier () {}

			public void trigger_started () {
				stdout.printf("Timer has started.\n");
			}

			public void trigger_finished () {
				stdout.printf("Timer has expired.\n");
			}
		}
	} /* Lite */
} /* Dayslice */