#lang racket

(require graph)
(require data/priority-queue)
(require while-until)

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

(define q (make-priority-queue 
           (λ (a b) (> (list-ref a 0)(list-ref b 0))))
  )

(for ([pair (combinations (get-vertices g) 2)])
  (define-values (a b) (apply values pair))
  (priority-queue-insert! q (list (distance a b) a b) )
  )

(define fully-connected #f)
(define last-edge '())

(for ([i (range 1000)])
  (define-values (dist p1 p2) (apply values (priority-queue-remove-max! q)))
  (add-edge! g p1 p2 dist)
  )

(while (and (not fully-connected) (not (priority-queue-empty? q)))
       (define-values (dist p1 p2) (apply values (priority-queue-remove-max! q)))
       (add-edge! g p1 p2 dist)
       (define connected (cc/bfs g))
       (set! fully-connected (and (= 1 (length connected)) (>= (length lines)(length connected))))
       (when fully-connected
         (set! last-edge (list dist p1 p2))
         )
       )

(displayln (* (list-ref (list-ref last-edge 1) 0) (list-ref (list-ref last-edge 2) 0)))