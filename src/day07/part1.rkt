#lang racket

(define DAY_INPUT "../../input/day07/input.txt")

(define lines (file->lines DAY_INPUT))

(define rows (length lines))
(define cols (string-length (list-ref lines 0)))

(define (char-at grid row col)
  (substring (list-ref grid row) col (add1 col))
  )


(define answer 0)

(for ([row (range 1 rows)])
  (for ([col (range cols)])
    (when (regexp-match? #px"[S|]" (char-at lines (sub1 row) col))
      (when (equal? "." (char-at lines row col))
        (string-set! (list-ref lines row) col #\|)
        )
      (when (equal? "^" (char-at lines row col))
        (when (equal? "." (char-at lines row (sub1 col)))
          (string-set! (list-ref lines row) (sub1 col) #\|)
          )
        (when (equal? "." (char-at lines row (add1 col)))
          (string-set! (list-ref lines row) (add1 col) #\|)
          )
        (set! answer (add1 answer))
        )
      )
    )
  )

(printf "Answer: ~v~n" answer)