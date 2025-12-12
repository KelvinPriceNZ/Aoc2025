#lang racket

(require algorithms)
(require iso-printf)

(define DAY_INPUT "../../input/day06/input.txt")

(define lines (file->lines DAY_INPUT))

(define calc '())

(for ([line lines])
  (set! calc (append calc (list (string-split line))))
  )

; transpose list of list
(define ops (apply map list (reverse calc)))

(define answer 0)

(for ([e ops])
  (define op (car e))
  (define vals (map string->number (cdr e)))
  (define result 0)
  (cond
    [(equal? op "*") (set! result (apply * vals))]
    [(equal? op "+") (set! result (apply + vals))]
    )
  (set! answer (+ answer result))
  )

(printf "Answer: %d\n" answer)