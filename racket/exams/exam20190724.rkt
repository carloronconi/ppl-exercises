#lang racket
#|
Write a functional, tail recursive implementation of a procedure that takes a list of numbers L and two values
x and y, and returns three lists: one containing all the elements that are less than both x and y, the second one
containing all the elements in the range [x,y], the third one with all the elements bigger than both x and y. It
is not possible to use the named let construct in the implementation.
|#

(define (split lst x y)
  (define (split-accum lst x y acc1 acc2 acc3)
    (cond ((empty? lst) (list acc1 acc2 acc3))
          (else
           (let ((first (car lst))
                 (rest (cdr lst)))
             (cond ((and (< first x) (< first y)) (split-accum rest x y (cons first acc1) acc2 acc3))
                   ((and (> first x) (> first y)) (split-accum rest x y acc1 acc2 (cons first acc3)))
                   (else (split-accum rest x y acc1 (cons first acc2) acc3)))))))

  (if (>= y x)
      (split-accum lst x y '() '() '())
      (error "y must be greater or equal than x")))

(split '(1 2 3 4 5 6 7 8 9) 3 7)

; all done by myself without looking at solution, correctly!