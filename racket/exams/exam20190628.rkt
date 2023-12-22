#lang racket
#|
(define (make-simple-object)
  (let (( my-var 0)) ; attribute

    ; methods
    (define (my-add x)
      (set! my-var (+ my-var x))
      my-var)

    (define (get-my-var )
      my-var )

    (define (my-display )
       (newline )
       (display " my Var is : " )
       (display my-var )
       (newline ))

    (lambda (message . args )
       (apply (case message
                  ((my-add) my-add)
                  ((my-display) my-display )
                  ((get-my-var) get-my-var )
                  (else ( error " Unknown Method ! " )))
               args ))))


(define a (make-simple-object))
(define b (make-simple-object))
(a ’my-add 3)
; => 3
(a ’my-add 4)
; => 7

|#

; done without looking at solutions below:

#|
(define (Leaf num)
  (let ((n num))

    (define (print)
      (display "(Leaf ")
      (display n)
      (display ")"))

    (define (map f)
      (set! n (f n))) 

    (lambda (message . args)
      (apply (case message
               ((print) print)
               ((map) map)
               (else (error "Unknown Method!")))
             args))))

(define (Branch leftt num rightt)
  (let ((lt leftt)
        (n num)
        (rt rightt))

    (define (print)
      (display "(Branch ")
      (lt 'print)
      (display " ")
      (display n)
      (display " ")
      (rt 'print)
      (display ")"))

    (define (map f)
      (set! lt (lt 'map f))
      (set! n (f n))
      (set! rt (rt 'map f)))

    (lambda (message . args)
      (apply (case message
               ((print) print)
               ((map) map)
               (else (error "Unknown Method!")))
             args))))

|#

; only issue in my sol: both map definitions don't return anything, while they should return "self/this" after
; modifying with set!. But there's no way to do that, so solutions actually just return a new object by using
; again the constructor. Other difference is that the sol didn't use attributes (the initial let) because by always
; returning a new branch it's probably not needed? But also works as I had done, below fixed maps:

(define (Leaf num)
  (let ((n num))

    (define (print)
      (display "(Leaf ")
      (display n)
      (display ")"))

    (define (map f)
      (Leaf (f n))) 

    (lambda (message . args)
      (apply (case message
               ((print) print)
               ((map) map)
               (else (error "Unknown Method!")))
             args))))

(define (Branch leftt num rightt)
  (let ((lt leftt)
        (n num)
        (rt rightt))

    (define (print)
      (display "(Branch ")
      (lt 'print)
      (display " ")
      (display n)
      (display " ")
      (rt 'print)
      (display ")"))

    (define (map f)
      (Branch (lt 'map f) (f n) (rt 'map f)))

    (lambda (message . args)
      (apply (case message
               ((print) print)
               ((map) map)
               (else (error "Unknown Method!")))
             args))))

; usage:
(define t1 (Branch (Branch (Leaf 1) -1 (Leaf 2)) -2 (Leaf 3)))
((t1 'map (lambda (x) (+ x 1))) 'print) ; should display: (Branch (Branch (Leaf 2) 0 (Leaf 3)) -1 (Leaf 4))