#lang racket

(define DAY_INPUT "../../input/day04/input.txt")

(define lines (file->lines DAY_INPUT))

(define rows (length lines))
(define cols (string-length (list-ref lines 0)))

(define (read-2d-grid-to-vector-of-vector filename)
  (let* ([lines (file->lines filename)]
         [list-of-lists (for/list ([line lines])
                          (string->list line))]
         [vector-of-vectors (for/vector ([row list-of-lists])
                              (list->vector row))])
    vector-of-vectors))

(define (find-neighbours matrix row col)
  (define num-rows (vector-length matrix))
  (define num-cols (if (> num-rows 0) (vector-length (vector-ref matrix 0)) 0))
  (define neighbors '())

  (define (add-neighbor r c)
    (when (and (>= r 0) (< r num-rows)
               (>= c 0) (< c num-cols))
      (set! neighbors (cons (vector-ref (vector-ref matrix r) c) neighbors))))

  ;; Check up
  (add-neighbor (- row 1) col)
  ;; Check down
  (add-neighbor (+ row 1) col)
  ;; Check left
  (add-neighbor row (- col 1))
  ;; Check right
  (add-neighbor row (+ col 1))

  (add-neighbor (- row 1) (- col 1))
  (add-neighbor (- row 1) (+ col 1))
  (add-neighbor (+ row 1) (- col 1))
  (add-neighbor (+ row 1) (+ col 1))
  

  neighbors)



(define grid (read-2d-grid-to-vector-of-vector DAY_INPUT))

(define answer 0)

(for ([r (range rows)])
  (for ([c (range cols)])
    (when (equal? (vector-ref (vector-ref grid r) c) #\@)
      (define rolls 0)
      (for ([n (find-neighbours grid r c)])
        (when (equal? n #\@)
          (set! rolls (add1 rolls)))
        )
      (when (< rolls 4)
        (set! answer (+ answer 1))
        )
      )
    )
  )

(printf "Answer: ~v~n" answer)