*** Settings ***
Library	     dayslicelite.py

*** Test Cases ***
Start and cancel a basic timer
      User was not notified of expired timer
      Set remaining minutes	10
      Start timer
      Timer should be running
      Cancel timer
      Timer should be idle

Alert a user when their timer has expired
      User was not notified of expired timer
      Set remaining minutes	25
      Start timer
      Step while running
      User was notified of expired timer
      Timer should be idle
