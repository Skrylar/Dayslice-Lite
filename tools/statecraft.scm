(import (scheme char))
(import (chibi))
(import (chibi loop))
(import (chibi match))

;;; state machine
(define fsm
  '((idle
     (tick . idle)
     (change_timeout . set)
     (set_break . running)
     (set_work . running))
    (set
     (tick . set)
     (change_timeout . set)
     (set_break . running)
     (set_work . running))
    (running
     (tick . running)
     (expire . expired)
     (change_timeout . running)
     (set_break . running)
     (set_work . running))
    (expired
     (tick . expired)
     (change_timeout . set)
     (set_break . running)
     (set_work . running))))

(define states '())
(define messages '())

;;; detect valid states
(loop ((for item (in-list fsm)))
      (set! states (cons (car item) states)))

;;; detect valid messages
(loop ((for state (in-list fsm)))
      ;; grab messages from the fsm table
      (loop ((for message (in-list (cdr state))))
	    (let ((message-name (car message)))
	      (if (eq? #f (memq message-name messages))
		  (set! messages (cons message-name messages))))))

;;; helpers
(define (valid-state? state)
  (not (eq? #f (memq state states))))

(display "namespace Dayslice.Lite {") (newline)
(display "public class FSM : Object {") (newline)

(display "public enum States {") (newline)
(loop ((for state (in-list states)))
      (display (string-upcase (symbol->string state)))
      (display ",")
      (newline))
(display "}") (newline) (newline)

(display "public enum Messages {") (newline)
(loop ((for message (in-list messages)))
      (display (string-upcase (symbol->string message)))
      (display ",")
      (newline))
(display "}") (newline) (newline)

(display "private States _state = States.IDLE;") (newline)
(display "public States state { get { return _state; } }") (newline)
(newline)

(loop ((for state (in-list fsm)))
      (let ((state-name (car state)))
	(display "public signal exited_")
	(display (string-downcase (symbol->string state-name)))
	(display " ();")
	(newline)

	(display "public signal entered_")
	(display (string-downcase (symbol->string state-name)))
	(display " ();")
	(newline)

	(display "private void _state_")
	(display (symbol->string state-name))
	(display " (Message message) {") (newline)
	(display "switch (message) {") (newline)
	(loop ((for dispatch (in-list (cdr state))))
	      (let ((message (car dispatch))
		    (destination (cdr dispatch)))
		(display "case Message.")
		(display (string-upcase (symbol->string message)))
		(display ":") (newline)

		;; OPTIMIZATION only plumb events that result in a state transition
		(if (not (eqv? destination state-name))
		    (begin
		      (display "_exited_")
		      (display (string-downcase (symbol->string state-name)))
		      (display " ();")
		      (newline)

		      (display "_state = _")
		      (display (string-downcase (symbol->string destination)))
		      (display ";")
		      (newline)

		      (display "_entered_")
		      (display (string-downcase (symbol->string destination)))
		      (display " ();")
		      (newline)))

		(display "break;") (newline)
		))
	(display "default: assert_not_reached (); break;") (newline)
	(display "}") (newline)
	(display "}") (newline) (newline)
	))

(display "} /* FSM */") (newline)
(display "} /* Dayslice.Lite */") (newline)
