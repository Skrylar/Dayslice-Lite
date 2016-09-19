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
