#lang racket

(define DAY_INPUT "../../input/day05/input.txt")

(define lines (file->lines DAY_INPUT))

(define ranges '())
(define count 0)

(for ([line lines])
  (when (regexp-match? #rx"^[0-9]+-[0-9]+$" line)
    (define range (regexp-split #rx"-" line))
    (set! ranges (append ranges (list range)))
    )
  (when (regexp-match? #rx"^[0-9]+$" line)
    (define ingredient (string->number line))
    (define found #f)
    (for ([r ranges])
      (define lo (string->number (list-ref r 0)))
      (define hi (string->number (list-ref r 1)))
      (when (and (>= ingredient lo)(<= ingredient hi))
        (set! found #t)
        )
      )
    (when found (set! count (add1 count)))
    )
  )

(printf "Answer: ~v~n" count)
