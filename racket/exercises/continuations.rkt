#lang racket

(+ 3
   (call/cc ; 2 arguments: the continuation and a tag??
    (lambda (exit) ; 1st arg: the continuation
      (for-each (lambda (x)
                  (when (negative? x)
                    (exit x)))
                '(54 0 37 -3 345 19) ; values used by of for-each
                ) ; end of for-each
      10 ;
      ) ; end of the outermost lambda
    ) ; end of call/cc
   ) ; end of (+ 3 ...)


(define fail #f)
(call/cc
 (lambda (cc)
   (set! fail
         (lambda ()
           (if (null? *paths*)
               (cc '!!failure!!)
               (let ((p1 (car *paths*)))
                 (set! *paths* (cdr *paths*))
                 (p1)))))))

(define *paths* '())
(define (choose choices)
  (if (null? choices)
      (fail)
      (call/cc
       (lambda (cc)
         (set! *paths*
               (cons (lambda ()
                       (cc (choose (cdr choices))))
                     *paths*))
         (car choices)))))

(define (is-the-sum-of sum)
  (unless (and (>= sum 0)(<= sum 10))
    (error "out of range" sum))
  (let ((x (choose '(0 1 2 3 4 5)))
        (y (choose '(0 1 2 3 4 5))))
    (if (= (+ x y) sum)
        (list x y)
        (fail))))