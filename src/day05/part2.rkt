#lang racket

(define DAY_INPUT "../../input/day05/input.txt")

(define lines (file->lines DAY_INPUT))

(define ranges '())
(define count 0)

(for ([line lines])
  (when (regexp-match? #rx"^[0-9]+-[0-9]+$" line)
    (define range (regexp-split #rx"-" line))
    (set! ranges (append ranges (list (map string->number range))))
    )
  )

; sort by 1st element
(set! ranges (sort ranges (λ (a b) (< (list-ref a 0) (list-ref b 0)))))

(define pos 0)

(for ([r ranges])
  (define lo (list-ref r 0))
  (define hi (list-ref r 1))
  (if (< pos lo)
      (begin
        (set! count (+ count (add1 (- hi lo))))
        (set! pos (add1 hi))
        )
      (if (and (>= pos lo) (<= pos hi))
          (begin
            (set! count (+ count (add1 (- hi pos))))
            (set! pos (add1 hi))
            )
          (void)  ; pos > hi, so already counted this range
          )
      )
  )

(printf "Answer: ~v~n" count)