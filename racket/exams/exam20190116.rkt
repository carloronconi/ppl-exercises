#lang racket
(define (inv x . rest)
  (let ((lst (cons x rest)))
    (foldl cons '() lst)))

(define lst '(1 2 3 4))

(inv 1 2 3 4 5)
(inv 1)

#|
I misunderstood assignment, let's try again
couldn't figure out how to concat an element with a list, as cons "flattens" the list.
Suggestion note:
> (list 1 2 '(3))
'(1 2 (3))
> (cons 1 '(2))
'(1 2) -> careful! This only works by putting the value first and the list second!
|#

(define (func . lst)
  (foldl list
         (foldl cons '() lst)
         lst))

#|
solution by prof: same but uselessly re-defines the function list as a lambda
|#

(define (f . L)
  (foldl (lambda (x y)
           (list x y))
         (foldl cons '() L)
         L))

(f 3 4 5)
(f)