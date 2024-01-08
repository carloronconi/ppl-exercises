#lang racket
#|
We want to implement a for-each/cc procedure which takes a condition, a list and a body and performs a for-each.
The main difference is that, when the condition holds for the current value, the continuation of the body is stored in
a global queue of continuations. We also need an auxiliary procedure, called use-cc, which extracts and call the
oldest stored continuation in the global queue, discarding it.

E.g. if we run:
(for-each/cc odd?
             '(1 2 3 4)
             (lambda (x) (displayln x)))
two continuations corresponding to the values 1 and 3 will be stored in the global queue.

Then, if we run: (use-scc), we will get on screen:
2
3
4
|#

#| first attempt mostly correct but had used foldr instead of foldl and had swapped (old)
(define cont-store '())

(define (for-each/cc cond lst body)
  (unless (null? lst)
    (let ((curr (car lst))
          (rest (cdr lst)))
      (body curr)
      (when (cond curr)
        (call/cc (lambda (cont)
                   (set! cont-store (cons cont cont-store)))))
      (for-each/cc cond rest body))))

(define (use-cc)
  (let* ((rev-cs (foldr cons '() cont-store)) ; 
         (old (car rev-cs))
         (rev-rest (cdr rev-cs)))
    (old)
    (set! cont-store (foldr cons '() rev-rest))))
|#

; my improved and fixed version
(define cont-store '())

(define (for-each/cc cond lst body)
  (unless (null? lst)
    (let ((curr (car lst))
          (rest (cdr lst)))
      (body curr)
      (when (cond curr)
        (call/cc (lambda (cont)
                   (set! cont-store (append cont-store (list cont)))))) ; simpler to use append and then car to implement queue
      (for-each/cc cond rest body))))

(define (use-cc)
  (when (cons? cont-store)
    (let ((old (car cont-store))
          (rest (cdr cont-store)))
      (set! cont-store rest) ; swapped this and (old), otherwise old, which is a GOTO, makes
      (old))))               ; you skip the execution of set!...

#| PROF's SOLUTION
(define *scc* '())

(define (use-cc)
  (when (cons? *scc*)
    (let ((c (car *scc*)))
      (set! *scc* (cdr *scc*))
      (c))))

(define (for-each/cc cnd L body)
  (when (cons? L)
    (let ((x (car L)))
      (call/cc (lambda (c)
                 (when (cnd x)
                   (set! *scc* (append *scc* (list c))))
                 (body x)))
      (for-each/cc cnd (cdr L) body))))
|#

(for-each/cc odd?
             '(1 2 3 4)
             (lambda (x) (displayln x)))
