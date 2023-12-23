#lang racket
(define x 4)
(define y 8)

(define (calc a b) (+ a b))

((lambda (k) (* 5 (+ k 4))) 2)

;((lambda (x y) (+ (* x x) (* y y))) 2 3)

(call/cc
  (lambda (k)
    (* 5 (k 4))))

(let ((x 2) (y (lambda (a b) (+ (* a a) (* b b)))))
  (y x x))

(define (aaa . bbb) bbb) ; weird: aaa is a procedure and it yields the parameters passed as a list
(define (ccc e) e)