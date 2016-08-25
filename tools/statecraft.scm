(import (scheme char))
(import (chibi))
(import (chibi loop))
(import (chibi match))

;;; state machine
(define fsm
  '((idle
     (tick . idle)
     (cancel . idle)
     (change_timeout . set)
     (set_break . running)
     (set_work . running))
    (set
     (tick . set)
     (cancel . idle)
     (change_timeout . set)
     (set_break . running)
     (set_work . running))
    (running
     (tick . running)
     (cancel . idle)
     (expire . expired)
     (change_timeout . running)
     (set_break . running)
     (set_work . running))
    (expired
     (tick . expired)
     (cancel . idle)
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

(display "public enum State {") (newline)
(loop ((for state (in-list states)))
      (display (string-upcase (symbol->string state)))
      (display ",")
      (newline))
(display "}") (newline) (newline)

(display "public enum Message {") (newline)
(loop ((for message (in-list messages)))
      (display (string-upcase (symbol->string message)))
      (display ",")
      (newline))
(display "}") (newline) (newline)

(display "private State _state = State.IDLE;") (newline)
(display "private delegate void StateFunction(Message m);") (newline)
(display "private StateFunction _state_fun;") (newline)
(display "public State state { get { return _state; } }") (newline)
(newline)

(display "public FSM () {") (newline)
(display "_state_fun = _state_idle;") (newline)
(display "}") (newline)
(newline)

(display "public void send (Message m)") (newline)
(display "requires (_state_fun != null)") (newline)
(display "ensures (_state_fun != null) {") (newline)
(display "_state_fun (m);") (newline)
(display "}") (newline)
(newline)

(loop ((for state (in-list fsm)))
      (let ((state-name (car state)))
	(display "public signal void exited_")
	(display (string-downcase (symbol->string state-name)))
	(display " ();")
	(newline)

	(display "public signal void entered_")
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
		      (display "exited_")
		      (display (string-downcase (symbol->string state-name)))
		      (display " ();")
		      (newline)

		      (display "_state = State.")
		      (display (string-upcase (symbol->string destination)))
		      (display ";")
		      (newline)
		      (display "_state_fun = _state_")
		      (display (string-downcase (symbol->string destination)))
		      (display ";")
		      (newline)

		      (display "entered_")
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
