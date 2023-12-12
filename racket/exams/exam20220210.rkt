#lang racket

; 0) pass in x which will be compared to first element of list, list
; 1) if second element of list is a list (i.e. argument list longer than two elements)
;    modify s to be its starting element only, otherwise make it 1: we are now ensured that
;    the input list is a pair either by truncating list or elongating input with 1
; 2) return a lambda closure without params which does the following:
;    if (x < starting element of list) return the value of x and increment the
;    closed variable x by the second element of the list
;    else (x >= starting element of list) it returns the starting element of the list

; testing if in Scheme with set! variables are copied or referenced => copy
; investigate if only for simple types or all types (e.g. also for functions?)
(define (test a)
  (let ((x a))
    (let ((y x))
      (begin
        (set! y (+ y 1))
        (displayln y)
        (displayln x)))))

; so it can be used as a factory for counter closures: the first parameter (x) is the
; starting value of the generated values of the factory, the first element of the pair (y)
; is the upper bound of the generated values and the optional (by default 1)
; second element (s) of the pair is the increment between one generated value and the next

; copying text to be able to run it (after writing example usage)
(define (r x y . s)
  (set! s (if (cons? s) (car s) 1))
  (lambda ()
    (if (< x y)
        (let ((z x))
          (set! x (+ s x))
          z)
        y)))

; example usage
(let (
      (counter (r 4 10 2 12 15))) ; parameters 12 and 15 are ignored, parameter 2 is optional
  (begin                          ; NOTE: only issue I had was i passed a list/pair as params y . s while it wants single params, why?
    (displayln (counter)) ; 4
    (displayln (counter)) ; 6
    (displayln (counter)) ; 8
    (displayln (counter)) ; 10
    (displayln (counter)) ; 10
    ))

; it makes sense to create a version of r without y, as the returned closure will return an unbounded value
; we could implement it as follows
(define (r-alt x . s)
  (set! s (if (cons? s) (car s) 1))
  (lambda ()
    (let ((z x))
      (set! x (+ s x))
      z)))

; example usage
(let (
      (counter (r-alt 4 2 100 1242))) 
  (begin
    (displayln (counter)) ; 4
    (displayln (counter)) ; 6
    (displayln (counter)) ; 8
    (displayln (counter)) ; 10
    (displayln (counter)) ; 12
    ))