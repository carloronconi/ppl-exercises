#lang racket

(define (plus1 x)
  (+ x 1))

(define (times2 x)
  (* x 2))

#| wrong solution
(define (list-to-compose first . rest)
  (if (null? rest)
      (first)
      (apply first (list-to-compose rest))))

(define (just3)
  (3))

(list-to-compose plus1 times2 just3)
|#

#|
(define (list-to-compose lst)
  (lambda (x)
    (foldr
     (lambda (y acc)
       (y acc))
     x lst)))
|#

(define (list-to-compose lst)
  (lambda (x)
    (foldr (lambda (y acc)
             (y acc)) x lst)))

;(let ((fun (list-to-compose '(plus1 times2))))
;  (displayln (fun 3)))

((list-to-compose '(plus1 times2)) 3)

