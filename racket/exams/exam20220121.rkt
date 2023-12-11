#lang racket

; Define a new construct called block-then which creates two scopes for variables, declared after the
; scopes, with two different binding. E.g. the evaluation of the following code:
; (block
;   ((displayln (+ x y))
;   (displayln (* x y))
;   (displayln (* z z)))
;   then
;   ((displayln (+ x y))
;   (displayln (* z x)))
;   where (x <- 12 3)(y <- 8 7)(z <- 3 2))
; should show on the screen:
; 20
; 96
; 9
; 10
; 6

(define-syntax block
  (syntax-rules (then were <-)
    ((block (body-l...) then (body-r...) where (var <- l r)...)
     (begin
        (let ((var l)...)
          body-l...)
        (let((var r)...)
          body-r...)))))

(block
   ((displayln (+ x y))
   (displayln (* x y))
   (displayln (* z z)))
   then
   ((displayln (+ x y))
   (displayln (* z x)))
   where (x <- 12 3)(y <- 8 7)(z <- 3 2))