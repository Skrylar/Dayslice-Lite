
import sys
sys.path.append("../build/dayslice_lite_roboticized@sha/")
sys.path.append("../build/")
import dayslice_lite_roboticized
dayslice_lite_roboticized.dayslice_lite_application_activate_testing_rig ()

def cancel_timer ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_cancel_timer () == True

def set_remaining_minutes (minutes):
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_set_remaining_minutes (int (minutes)) == True

def start_timer ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_start_timer () == True

def step_while_running ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_step_while_running () == True

def timer_should_be_idle ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_timer_should_be_idle () == True

def timer_should_be_running ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_timer_should_be_running () == True

def user_was_notified_of_expired_timer ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_user_was_notified_of_expired_timer () == True

def user_was_not_notified_of_expired_timer ():
    assert dayslice_lite_roboticized.dayslice_lite_robot_overlord_user_was_not_notified_of_expired_timer () == True
