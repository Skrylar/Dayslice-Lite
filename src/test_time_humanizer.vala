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
namespace Dayslice.Lite.Testing {
	void minute_humanization () {
		Test.add_func ("/dayslice/minute_humanization", () => {
				assert (TimeHumanizer.from_minutes (1) == "1 minute");
				assert (TimeHumanizer.from_minutes (30) == "30 minutes");
				assert (TimeHumanizer.from_minutes (60) == "1 hour");
				assert (TimeHumanizer.from_minutes (65) == "1 hour 5 minutes");
				assert (TimeHumanizer.from_minutes (120) == "2 hours");
				assert (TimeHumanizer.from_minutes (130) == "2 hours 10 minutes");
				assert (TimeHumanizer.from_minutes (121) == "2 hours 1 minute");
			});
	}

	void main (string[] args) {
		Test.init (ref args);
		minute_humanization ();
		Test.run ();
	}
} /* Dayslice.Lite.Testing */