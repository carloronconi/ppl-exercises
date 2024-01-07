#lang racket
#|
1) Define a procedure which takes a natural number n and a default value, and creates a n by n matrix filled
with the default value, implemented through vectors (i.e. a vector of vectors).

2) Let S = {0, 1, ..., n-1} x {0, 1, ..., n-1} for a natural number n. Consider a n by n matrix M, stored in
a vector of vectors, containing pairs (x,y) ∈ S, as a function from S to S (e.g. f(2,3) = (1,0) is represented
by M[2][3] = (1,0)). Define a procedure to check if M defines a bijection (i.e. a function that is both
injective and surjective).
|#

; 1) all correct apart from 0 based indexing
(define (create-matrix-rec n d next vec-of-vec)
  (if (< next n) ; vector indexing is 0 based!
      (begin
        (vector-set! vec-of-vec next (make-vector n d)) ; make-vector found in theory slides out of luck
        (create-matrix-rec n d (+ next 1) vec-of-vec))
      vec-of-vec))

(define (create-matrix n d)
  (create-matrix-rec n d 0 (make-vector n #())))

; 2)
; my original solution looks good but without call/cc it always returns false!!
; couldn't find an explaination, booleans are mutable
(define (check-bi M)
  (let* ((size (vector-length M))
         (check (create-matrix size #f))
         (flag #t))
    (let loopi ((i 0))
      (when (< i size)
        (let loopj ((j 0))
          (when (< j size)
            (let* ((mypair (vector-ref (vector-ref M i) j)) (x (car mypair)) (y (car (cdr mypair))))
              (if (vector-ref (vector-ref check x) y)
                  (set! flag #f)
                  (vector-set! (vector-ref check x) y #t))
            (loopj (+ j 1))))
        (loopi (+ i 1)))))
    ;(when flag
    ; (set! flag (equal? check (create-matrix size 1)))) not needed: if iterated over all positions already sure it's surjective
    flag))

; same as original but adding call/cc works!
; lesson learnt: don't use flags
(define (check-bi2 M)
  (let* ((size (vector-length M))
         (check (create-matrix size #f)))
    (call/cc (lambda (exit)
               (let loopi ((i 0))
                 (when (< i size)
                   (let loopj ((j 0))
                     (when (< j size)
                       (let* ((mypair (vector-ref (vector-ref M i) j)) (x (car mypair)) (y (car (cdr mypair))))
                         (if (vector-ref (vector-ref check x) y)
                             (exit #f)
                             (vector-set! (vector-ref check x) y #t)))
                       (loopj (+ j 1))))
                   (loopi (+ i 1))))
               #t))))

#|
attempt avoiding call/cc with mutable vector instead of boolean still didn't work
(define (check-bi M)
  (let* ((size (vector-length M))
         (check (create-matrix size #f))
         (flag (make-vector 1 1)))
         ;(flag #t))
    (let loopi ((i 0))
      (when (< i size)
        (let loopj ((j 0))
          (when (< j size)
            (let* ((mypair (vector-ref (vector-ref M i) j)) (x (car mypair)) (y (car (cdr mypair))))
              (if (vector-ref (vector-ref check x) y)
                  ;(set! flag #f)
                  (vector-set! flag 0 0)
                  (vector-set! (vector-ref check x) y #t))
            (loopj (+ j 1))))
        (loopi (+ i 1)))))
    ;(when flag
    ; (set! flag (equal? check (create-matrix size 1)))) not needed: if iterated over all positions already sure it's surjective

    ;flag))
    (vector-ref flag 0)))
|#


(check-bi #(#((0 0) (0 1)) #((1 0) (1 1))))
(check-bi2 #(#((0 0) (0 1)) #((1 0) (1 1))))

; PROF's SOLUTION BELOW
#|
(define (create-matrix size default)
  (define vec (make-vector size #f))
  (let loop ((i 0))
    (if (= i size)
        vec
        (begin
          (vector-set! vec i (make-vector size default))
          (loop (+ 1 i))))))
|#

(define (bijection? m)
  (define size (vector-length m))
  (define seen? (create-matrix size #f))
  (call/cc (lambda (exit)
             (let loop ((i 0))
               (when (< i size)
                 (let loop1 ((j 0))
                   (when (< j size)
                     (let ((datum (vector-ref (vector-ref m i) j)))
                       (if (vector-ref (vector-ref seen? (car datum))
                                       (car (cdr datum)))
                           (exit #f)
                           (vector-set! (vector-ref seen? (car datum)) (car (cdr datum)) #t)))
                     (loop1 (+ 1 j))))
                 (loop (+ 1 i))))
             #t)))


(bijection? #(#((0 0) (0 1)) #((1 0) (1 1))))


    