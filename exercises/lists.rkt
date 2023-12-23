#lang racket
(define (my-proc x y)
  (+ (* x x) (* y y))) 

(let ((a 3)
      (b 2))
  (my-proc a b))

(define (make-list x . y)
  (printf "called with ~a ~a \n" x y)
  (if (null? y)
      (list x)
      (cons x (apply make-list y)))) ; apply required otherwise calls make-list with the list: so could just concatenate to y?

(make-list 1 2 3 4 5)
(make-list 1)

(define (make-list-simpler x . y) 
  (cons x y))

(make-list-simpler 1 2 3 4 5)
(make-list-simpler 1) ; yes it works exactly like previous

; named let: loops
(define (find-min-named-let lst)
  (let loop ((l lst) (min (car lst))) ; take starting min as arbitrary value: car of the list
    (let ((elm (car l)) (rest (cdr l)))
      (if (null? rest)
          (if (< elm min)
              elm
              min)
          (begin
            (when (< elm min)
                (set! min elm))
            (loop rest min))))))

(find-min-named-let '(7 14 3 4 8))

; named let without bindings: made "thinking in C" which arguably makes it worse?
(define (find-min-C-like lst)
  (let ((min (car lst)) (i 0))
    (let loop ()
      (begin
        (when (< (list-ref lst i) min)
          (set! min (list-ref lst i)))
        (if (< (+ i 1) (length lst))
            (begin
              (set! i (+ i 1))
              (loop))
            min)))))

(find-min-C-like '(4 9 6 3 8))

; use for-each instead: this should really make it simpler
(define (find-min-for-each lst)
  (let ((min (car lst)))
    (begin
      (for-each (lambda (elm)
                  (when (< elm min)
                    (set! min elm)))
                lst)
      min)))

(find-min-for-each '(4 9 6 3 8))




