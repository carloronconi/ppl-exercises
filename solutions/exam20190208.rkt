#lang racket
#| leaving my attempt below as it was close but way too complex

; return list of first elements of list of lists
(define (firsts lists)
  (map (lambda (lst) (car lst)) lists))

; return min of a list
(define (min elms)
  (foldl
   (lambda (a b) (if (< a b) a b))
   (car elms)
   (cdr elms)))

; remove elem from first list where you find it
(define (rmv elm lists)
  (if (= elm (caar lists))
      (cons (cdr (car lists)) (cdr lists))
      (cons (car lists) (rmv elm (rest lists)))))

(define (mf lists)
  (min (firsts lists)))
 
(firsts '((1 2 3 4 8) (-1 5 6 7) (0 3 8) (9 10 12)))
(min (firsts '((1 2 3 4 8) (-1 5 6 7) (0 3 8) (9 10 12))))
(mf '((1 2 3 4 8) (-1 5 6 7) (0 3 8) (9 10 12)))

(rmv -1  '((1 2 3 4 8) (-1 5 6 7) (0 3 8) (9 10 12)))
(rmv 1  '((1 2 3 4 8) (-1 5 6 7) (0 3 8) (9 10 12)))

(define (multi-merge lists)
  (let ((result '()))
    (let loop ((l lists))
      (let ((m (mf l)))
        (set! result (cons result m))
        (loop (rmv m l))))
    result))

|#

; solving after I saw the solution 

(define (merge-two llist rlist)
  (cond ((null? llist) rlist) ; only one at a time will become null at some point
        ((null? rlist) llist)
        (else (let ((l (car llist))
                    (r (car rlist)))
                (if (< l r)
                    (cons l (merge-two (cdr llist) rlist))
                    (cons r (merge-two llist (cdr rlist))))))))
  
(define (multi-merge . lists)
  (foldl merge-two '() lists))
    