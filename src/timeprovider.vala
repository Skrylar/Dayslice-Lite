namespace Dayslice.Lite {
	public interface TimeProvider : GLib.Object {
		public abstract DateTime now ();
	}

	public class RealTimeProvider : GLib.Object, TimeProvider {
		public DateTime now () {
			return new DateTime.now_local ();
		}
	}
} /* Dayslice.Lite */
