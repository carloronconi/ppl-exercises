#lang racket

#|
Consider the following code:

(define (a-function lst sep)
  (foldl (lambda (el next)
           (if (eq? el sep)
               (cons '() next)
               (cons (cons el (car next))
                     (cdr next))))
         (list '()) lst))

1) Describe what this function does; what is the result of the following call?
(a-function '(1 2 nop 3 4 nop 5 6 7 nop nop 9 9 9) 'nop)
2) Modify a-function so that in the example call the symbols nop are not discarded from the resulting list,
which must also be reversed (of course, without using reverse).

(define (a-function lst sep)
  (foldl (lambda (el next)
           (if (eq? el sep)
               (cons '() next)
               (cons (cons el (car next))
                     (cdr next))))
         '(()) lst))

1 (())
> 1 . () . null = (1)
2 (1)
> 2 . 1 . null = (2 1)
nop (2 1)
> () . (2 1) = (() (2 1))
3 (() (2 1))
> 3 . () . (2 1) = (3) . (2 1) = ((3) (2 1))
4 ((3) (2 1))
> (4 3) . (2 1) = ((4 3) (2 1))
nop ((4 3) (2 1))
> (() ((4 3) (2 1)))
5 (() ((4 3) (2 1)))
> ((5) (4 3) (2 1)) ...
((9 9 9) () (7 6 5) (4 3) (2 1))

it separates the items in different lists depending on the separator, outputting a reversed list of lists

modified version:
(b-function '(1 2 nop 3 4 nop 5 6 7 nop nop 9 9 9) 'nop)
|#

(define (b-function lst sep)
  (foldl (lambda (el next)
           (if (eq? el sep)
               (cons '() (list el next)) ; -> first attempt wrong: I don't get why the "list" needs to be a "cons" instead!! sol did yet another way: (cons (list el) next)
               (cons (cons el (car next))
                     (cdr next))))
         (list '()) lst))

(b-function '(1 2 nop 3 4 nop 5 6 7 nop nop 9 9 9) 'nop)

