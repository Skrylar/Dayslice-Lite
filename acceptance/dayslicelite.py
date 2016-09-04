
import sys
sys.path.append("../build/dayslice_lite_roboticized@sha/")
sys.path.append("../build/")
import dayslice_lite_roboticized
dayslice_lite_roboticized.dayslice_lite_application_activate_testing_rig ()

def cancel_timer ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_cancel_timer ()

def set_remaining_minutes (minutes):
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_set_remaining_minutes (int (minutes))

def start_timer ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_start_timer ()

def step_while_running ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_step_while_running ()

def timer_should_be_idle ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_timer_should_be_idle ()

def timer_should_be_running ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_timer_should_be_running ()

def user_was_notified_of_expired_timer ():
    dayslice_lite_roboticized.dayslice_lite_robot_overlord_user_was_notified_of_expired_timer ()

