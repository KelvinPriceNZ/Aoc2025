#lang racket

(require algorithms)
;(require iso-printf)

(define DAY_INPUT "../../input/day06/input.txt")

(define lines (file->lines DAY_INPUT))

(define calc '())

(for ([line lines])
  (set! calc (append calc (list (string-split line ""))))
  )

; transpose list of list
(define ops (apply map list (reverse calc)))

(define opr "")
(define answer 0)
(define operands '())

(for ([e ops])
  (define op (car e))
  (define vals (reverse (cdr e)))
  (define l (string->number (string-join (filter (λ (s) (regexp-match? #px"[0-9]{1}" s)) vals) "")))
  (define result 0)

  (if l
      (if (regexp-match? #px"[+*]" op)
          (begin
            (set! opr op)
            (set! operands (append operands (list l)))
            )
          (
           begin
            (set! operands (append operands (list l)))
            )
          )
      (begin
        (cond
          [(equal? opr "*") (set! result (apply * operands))]
          [(equal? opr "+") (set! result (apply + operands))]
          )
        (set! answer (+ answer result))
        (set! operands '())
        )
      )
  )

(printf "Answer: ~v~n" answer)