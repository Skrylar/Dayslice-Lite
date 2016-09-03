%module dayslice_lite_roboticized

%{
#include "dayslice_lite_roboticized.h"
%}

%typemap(in) gint {
  $1 = PyInt_AsLong ($input);
}

%typemap(out) gboolean {
  $result = PyBool_FromLong ($1);
}

void dayslice_lite_application_activate_testing_rig ();
gboolean dayslice_lite_robot_overlord_cancel_timer ();
gboolean dayslice_lite_robot_overlord_set_remaining_minutes (gint minutes);
gboolean dayslice_lite_robot_overlord_start_timer ();
gboolean dayslice_lite_robot_overlord_step_while_running ();
gboolean dayslice_lite_robot_overlord_timer_should_be_idle ();
gboolean dayslice_lite_robot_overlord_timer_should_be_running ();
gboolean dayslice_lite_robot_overlord_user_was_notified_of_expired_timer ();
