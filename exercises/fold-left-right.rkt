#lang racket
(define (fold-left-right f i L)
  (fold-l-r f i i L))

(define (fold-l-r f il ir L)
  (if (null? L)
      (list il ir)
      (let ((res (fold-l-r f (f (car L) il) ir (cdr L))))
        (list
         (car res)
         (f (car L) (cadr res))))))

(fold-left-right string-append "" '("a" "b" "c"))

; Sol giorgio
(define (_foldlr f z lst acc z1)
  (if (null? lst)
      (list z (acc z1))
      (let* [(x (car lst)) (xs (cdr lst))]
        (_foldlr f (f z x) xs (lambda (right-z) (acc (f right-z x))) z1))))

(define (foldlr f z lst)
  (_foldlr f z lst (lambda (right-z) right-z) z))


(foldlr string-append "" '("a" "b" "c"))


(define (mfun names bodies)
  (lambda (name args)
    (let loop ((f names) (b bodies))
      (if (not (or (null? f) (null? b)))
          (if (equal? name (car f))
              ((car b) args)
              (loop (cdr f) (cdr b)))
          (error "func not found!")))))


(define names (list "add1" "sub1"))
(define funcs (list (lambda (x) (+ x 1)) (lambda (x) (- x 1))))
(define multi (mfun names funcs))

(multi "add1" 5)
(multi "sub1" 3)
