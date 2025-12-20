#lang racket

(define DAY_INPUT "../../input/day09/input.txt")

(define lines (file->lines DAY_INPUT))

(define red-tiles '())

(for ([line lines])
  (define-values (x y) (apply values (map string->number (string-split line ","))))
  (set! red-tiles (cons (list x y) red-tiles))
  )

(define areas '())

(for ([p (combinations red-tiles 2)])
  (define-values (p1 p2) (apply values p))
  (define-values (x1 y1) (apply values p1))
  (define-values (x2 y2) (apply values p2))
  (set! areas (cons (* (+ 1 (abs (- x1 x2))) (+ 1 (abs (- y1 y2)))) areas))
  )

(displayln (apply max areas))
