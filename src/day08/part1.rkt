#lang racket

(require graph)

(define DAY_INPUT "../../input/day08/input.txt")

(define lines (file->lines DAY_INPUT))

(define (sq x)
  (* x x)
  )

(define (distance p q)
  (define-values (px py pz) (apply values p))
  (define-values (qx qy qz) (apply values q))
  (sqrt (+ (sq (- px qx)) (sq (- py qy)) (sq (- pz qz))))
  )

(define g (weighted-graph/undirected '()))

(for ([line lines])
  (define-values (x y z) (apply values (map string->number (string-split line ","))))
  (add-vertex! g (list x y z))
  )

(define wires '())

(for ([pair (combinations (get-vertices g) 2)])
  (define-values (a b) (apply values pair))
  (set! wires (cons (list (distance a b) a b) wires))
  )

(for ([e (take (sort wires (λ (a b) (< (list-ref a 0) (list-ref b 0)))) 1000)])
  (define-values (dist p1 p2) (apply values e))
  (add-edge! g p1 p2 dist)
  )

(apply * (take (sort (map length (cc g)) >) 3))