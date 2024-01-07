#lang racket
#|
Define a defun construct like in Common Lisp, where (defun f (x1 x2 ...) body) is used for defining a function f with
parameters x1 x2 .... Every function defined in this way should also be able to return a value x by calling (ret x).

My attempt
(define-syntax defun
  (syntax-rules ()
    (_ f (pars ...) body ...)
    (define (f pars ...)
      (begin body ...))))

Couldn't do it :(
Prof's solution below:
|#

(define ret-store '())

(define (ret v)
  ((car ret-store) v))

(define-syntax defun
  (syntax-rules ()
    ((_ fname (var ...) body ...)
     (define (fname var ...) ; <- define line
       (let ((out (call/cc (lambda (c)
                             (set! ret-store (cons c ret-store))
                             body ...)))) ; <- comment about this below (*)
         (set! ret-store (cdr ret-store))
         out)))))

#|
Comment (*)
when "defun" is used, it defines a function with, inside its body, all the things below the
define line. THe function is just defined at this stage, not executed. The function passed to the
macro could or could not contain the usage of a "ret" statement.

When calling the function the lines below the define line are executed: the let
statement stores in the variable out the result of the call/cc block, which is executed straight
away. The block saves in ret-restore the "GOTO position" which is right after the out variable.


If the body of the function didn't contain a "ret" statement, the body is executed normally and
as usual the value produced by its last statement is returned by the call/cc block (as with any block)
and assigned to the out variable, like in a normal define.

If instead it did contain a "(ret x)" statement, when it is reached it's like `(c x)` was called,
which means we GOTO the `let ((out x))` with x, so out will return the value x.
|#

; example usage
(defun my-fun (x)
  (* x 2)
  (ret 5)
  (+ x 1))

(defun prova (x)
  (ret 8))