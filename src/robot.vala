namespace Dayslice.Lite {
	// hello. i am your friendly robot overlord. i provide verbs for
	// the robot framework to run acceptance tests on this program to
	// make sure it isn't a broken piece of shit. beep boop.
	public class RobotOverlord : GLib.Object {
		public RobotOverlord () {}
		~RobotOverlord () {}

		// used to emulate gapplication functionality during testing
		public static MainContext main_context;

		public static MainWindow main_window;

		public static void sync () {
			assert_nonnull (main_context);
			assert_nonnull (main_window);
			main_context.acquire ();
			while (main_context.iteration (false)) {}
			main_context.release ();
		}

		public static bool cancel_timer () {
			sync ();
			main_context.acquire ();
			main_window.cancel ();
			main_context.release ();
			sync ();
			return true;
		}

		public static bool set_remaining_minutes (int minutes) {
			sync ();
			main_context.acquire ();
			main_window.timeout_adjustment.value = (double)(minutes / 5);
			main_context.release ();
			sync ();
			return true;
		}

		public static bool start_timer () {
			sync ();
			main_context.acquire ();
			main_window.start ();
			main_context.release ();
			sync ();
			return true;
		}

		public static bool step_while_running () {
			sync ();
			main_context.acquire ();
			while (main_window.state_machine.state == FSM.State.RUNNING) {
				((MockTimeProvider)main_window.time_provider).step (1);
				main_window.on_tick ();
			}
			// TODO
			main_context.release ();
			sync ();
			return true;
		}

		public static bool timer_should_be_idle () {
			sync ();
			return main_window.state_machine.state == FSM.State.IDLE;
		}

		public static bool timer_should_be_running () {
			sync ();
			return main_window.state_machine.state == FSM.State.RUNNING;
		}

		public static bool user_was_notified_of_expired_timer () {
			sync ();
			return ((MockNotifier)main_window.user_notifier).has_finished ();
		}

		public static bool user_was_not_notified_of_expired_timer () {
			sync ();
			return !((MockNotifier)main_window.user_notifier).has_finished ();
		}
	}
} /* Dayslice.Lite */
