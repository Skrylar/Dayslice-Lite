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
	public class TimeHumanizer {
		public static string from_minutes (int minutes) {
			int hours = minutes / 60;
			int minute_mod = minutes % 60;
			bool plural = minute_mod != 1;

			if (minutes < 1) {
				return "0 minutes";
			} else if (hours == 0) {
				if (plural) {
					return @"$minute_mod minutes";
				} else {
					return @"$minute_mod minute";
				}
			} else if (hours == 1) {
				if (minute_mod > 0) {
					if (plural) {
						return @"$hours hour $minute_mod minutes";
					} else {
						return @"$hours hour $minute_mod minute";
					}
				} else {
					return @"$hours hour";
				}
			} else {
				if (minute_mod > 0) {
					if (plural) {
						return @"$hours hours $minute_mod minutes";
					} else {
						return @"$hours hours $minute_mod minute";
					}
				} else {
					return @"$hours hours";
				}
			}
		}
	}
} /* Dayslice.Lite */
