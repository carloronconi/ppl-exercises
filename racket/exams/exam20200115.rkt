#lang racket
#|
Consider the Foldable and Applicative type classes in Haskell. We want to implement something
analogous in Scheme for vectors. Note: you can use the following library functions in your code:
vector-map, vector-append.
1) Define vector-foldl and vector-foldr.
2) Define vector-pure and vector-<*>.

From my notes:
instance Foldable [] where
foldr f z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

(define (fold-left f i L )
  (if ( null ? L )
      i
      (fold-left f
                 (f ( car L ) i )
                 (cdr L ))))

(define (fold-right f i L )
  (if ( null ? L )
      i
      (f ( car L )
         (fold-right f i ( cdr L )))))

concat l = foldr (++) [] l
concatMap f l = concat $ fmap f l
pure x = [x]
fs <*> xs = concatMap (\f -> fmap f xs) fs

|#

(define (old-vector-foldr f z vec)
  (if (= 0 (vector-length vec))
      (z)
      (f (car vec) (foldr f z (cdr vec))))) ; no cdr

(define (old-vector-foldl f z vec)
  (if (= 0 (vector-length vec))
      (z)
      (vector-foldl f
                    (f (vector-ref vec 0) z)
                    (cdr vec)))) ; no cdr

; not ideal to use pure recursion (as done for lists) as no easy way to access cdr
; checked sol to see if compulsory to use recursion: not compulsory (didn't see impl)

(define (vector-foldr f z vec)
  (let loop ((idx (- (vector-length vec) 1))
             (acc z))
    (if (= idx -1)
        (acc)
        (loop (- idx 1) (f  (vector-ref vec idx) acc)))))

(define (vector-foldl f z vec)
  (let loop ((idx 0)
             (acc z))
    (if (= idx (vector-length vec))
        (acc)
        (loop (+ idx 1) (f  (vector-ref vec idx) acc)))))

(define (vector-pure)
  #())

(define (concat v)
  (vector-foldr vector-append #() v))

(define (concat-map f v)
  (concat (vector-map f v)))

(define (vector-<*> farr varr)
  (concat-map (lambda (f) (vector-map f varr))
              farr))
  
