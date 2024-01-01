#lang racket
(define numbers '(1 2 3 4 5 6 7 8))

(define show-sum (λ (x acc)
                   (displayln (string-append "x = " (~a x) "; acc = " (~a acc)))
                   (+ x acc)))

(foldl show-sum
       0
       numbers)

(define (x . y) y)

(x 1 2 3)
(x)
(x '(1 2 3))

(define (x2 y) y)

; (x2 1 2 3) error number of arguments: found 3 but expected 1
(x2 1)

(define (x3 a b . c)
  (begin
    (display a)
    (newline)
    (display b)
    (newline)
    (display c)
    (newline)))

;(x3 1) error number of arguments: found 1 but expected at least 2
(x3 1 2)
(x3 1 2 3)
(x3 1 2 3 4)

(define (test . arg)
  (let ((x (car arg))
        (y (cdr arg)))
    (display x)
    (newline)
    (display y)
    (newline)))

(newline)
(test 1 2 3)