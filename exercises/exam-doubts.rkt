#lang racket
(define numbers '(1 2 3 4 5 6 7 8))

(define show-sum (λ (x acc)
                   (displayln (string-append "x = " (~a x) "; acc = " (~a acc)))
                   (+ x acc)))

(foldl show-sum
       0
       numbers)
