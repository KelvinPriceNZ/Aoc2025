#lang racket

(define (maxjolt n)
(apply max (map (λ (s) (string->number s)) (map (λ (s) (string-join s "")) (combinations (filter (λ (s) (positive? (string-length s))) (string-split  n "")) 2))))
  )

(define DAY_INPUT "../../input/day03/input.txt")

(define lines (file->lines DAY_INPUT))

(printf "Answer: ~v~n" (foldl + 0 (map maxjolt lines)))