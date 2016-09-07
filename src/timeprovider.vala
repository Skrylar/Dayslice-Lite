namespace Dayslice.Lite {
	public interface TimeProvider : GLib.Object {
		public abstract DateTime now ();
	}

	public class RealTimeProvider : GLib.Object, TimeProvider {
		public DateTime now () {
			return new DateTime.now_local ();
		}
	}

	public class MockTimeProvider : GLib.Object, TimeProvider {
		private int64 _now = 0;

		public DateTime now () {
			return new DateTime.from_unix_utc (_now);
		}

		public void step (int minutes)
		requires (minutes >= 0) {
			_now += minutes * TimeSpan.MINUTE;
		}
	}
} /* Dayslice.Lite */
