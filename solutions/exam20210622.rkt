#lang racket

#|
Define a function mix which takes a variable number of arguments x0 x1 x2 ... xn, the first one a function,
and returns the list (x1 (x2 ... (x0(x1) x0(x2) ... x0(xn)) xn) xn-1) ... x1).
E.g.(mix (lambda (x) (* x x)) 1 2 3 4 5) returns:  '(1 (2 (3 (4 (5 (1 4 9 16 25) 5) 4) 3) 2) 1)


(define (mixargs m x . xs) ; initially tried to use pattern-match in signature but wrong: only works for single single args (as in mix call example)
  (if (null? x)
      m
      (list x (mixargs m xs) x))) 

(define (mix f . args)
  (mixargs (map f args) args))

|#

; my solution: correct after running

(define (mixargs m lst)
  (if (null? lst)
      m
      (let ((x (car lst))
            (xs (cdr lst)))
        (list x (mixargs m xs) x)))) 

(define (mix f . args)
  (mixargs (map f args) args))

; prof's solution: more elegant

(define (f g . L)
  (foldr (lambda (x y)
           (list x y x))
         (map g L)
         L))