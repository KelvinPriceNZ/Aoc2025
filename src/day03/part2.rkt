#lang racket

(define (index-of-max lst)
  (if (empty? lst)
      #f ; Return #f for an empty list, or handle as appropriate
      (let loop ((current-list (cdr lst))
                 (max-val (car lst))
                 (max-idx 0)
                 (current-idx 1))
        (if (empty? current-list)
            max-idx
            (let ((next-val (car current-list)))
              (if (> next-val max-val)
                  (loop (cdr current-list) next-val current-idx (+ current-idx 1))
                  (loop (cdr current-list) max-val max-idx (+ current-idx 1))))))))

(define (maxjolt n l)
  (define digits (map (λ (i) (- i (char->integer #\0))) (map char->integer (string->list n))))
  (define answer 0)
  (define p1 0)
  (for ([p2 (reverse (range 0 l))])
    (define slice (drop (reverse (drop (reverse digits) p2)) p1))
    (define p (index-of-max slice))
    (set! answer (+ (* answer 10) (list-ref slice p)))
    (set! p1 (add1 (+ p1 p)))
    )
  answer
  )

(define DAY_INPUT "../../input/day03/input.txt")

(define lines (file->lines DAY_INPUT))

(printf "Answer: ~v~n" (foldl + 0 (map (λ (num) (maxjolt num 12)) lines)))