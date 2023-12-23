#lang racket
#|
Implement this new construct: (each-until var in list until pred : body), where keywords are written in
boldface. It works like a for-each with variable var, but it can end before finishing all the elements of list
when the predicate pred on var becomes true.
E.g.
(each-until x in '(1 2 3 4)
until (> x 3) :
(display (* x 3))
(display " "))
shows on the screen: 3 6 9

|#

#|
; first attempt
(define-syntax each-until
  (syntax-rules (in until :)
    ((each-until var in lst until pred : body)    ; missing the "..." (I thought that body would capture everything)
     ((set! var (car l))                          ; var is undefined! you need to use a let to define it first
      (let loop ((l lst))
        (when (and (not (empty? lst))
                   (pred))                        ; I misunderstood, this also needs a "not"
          (body)                                  ; these parenteses try to evaluate it while actually you just want to paste it here
          (set! var (car (cdr l)))
          (loop (cdr l))))))))
; re-done correctly below
|#

; second (working) attempt
(define-syntax each-until
  (syntax-rules (in until :)
    ((each-until var in lst until pred : body ...)
     (let loop ((l lst)
                (var (car lst)))
        (when (and (not (empty? l)) (not pred))
          body ...
          (loop (cdr l) (car (cdr l))))))))

#|
solution:
(define-syntax each-until
  (syntax-rules (in until :)
    ((_ x in L until pred : body ...)
     (let loop ((xs L))
       (unless (null? xs)
         (let ((x (car xs)))
           (unless pred
             (begin
               body ...
               (loop (cdr xs))))))))))
|#

(each-until x in '(1 2 3 4) until (> x 3) :
            (display (* x 3))
            (display " "))