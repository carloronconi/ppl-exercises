#lang racket

#|
Define the construct define-with-types, that is used to define a procedure with type constraints, both for the
parameters and for the return value.
The type constraints are the corresponding type predicates, e.g. number? to check if a value is a number.
If the type constraints are violated, an error should be issued.

E.g.
(define-with-types (add-to-char : integer? (x : integer?) (y : char?))
  (+ x (char->integer y)))
defines a procedure called add-to-char, which takes an integer and a character, and returns an integer.
|#

; (fixed) errors in comments
(define-syntax define-with-types
  (syntax-rules (:)
    ((_ (proc-name : ret-t (par : par-t) ...) body ...)
     (define (proc-name par ...) ; extra open parenthesis here
        (if (and (par-t par) ...)
            (let ((ret (begin body ...))) ; missing "begin" here
              (if (ret-t ret)
                  ret ; extra open and closed paretheses here
                  (error "Return type constraints violated")))
            (error "Parameter type constraints violated")))))) ; extra closed parenthesis here

; test
(define-with-types (add-to-char : integer? (x : integer?) (y : char?))
  (+ x (char->integer y)))

(add-to-char 3 #\a) ; works normally
(add-to-char 3 5) ; raises parameter type error

(define-with-types (add-to-char2 : char? (x : integer?) (y : char?))
  (+ x (char->integer y)))

(add-to-char2 3 #\a) ; raises return type error 