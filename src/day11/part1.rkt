#lang racket

(require graph)
(require data/queue)
(require while-until)

(define DAY_INPUT "../../input/day11/input.txt")

(define lines (file->lines DAY_INPUT))

(define g (unweighted-graph/directed '()))

(add-vertex! g "out")

(for ([line lines])
  (define nodes (string-split line " "))
  (define src (regexp-replace #rx":$" (car nodes) ""))
  (add-vertex! g src)
  )

(for ([line lines])
  (define nodes (string-split line " "))
  (define src (regexp-replace #rx":$" (car nodes) ""))
  (for ([edge (cdr nodes)])
    (add-directed-edge! g src edge)
    )
  )

(define n-paths 0)
(define q (make-queue))

(enqueue! q "you")

(while (non-empty-queue? q)
       (define curr-node (dequeue! q))
       (for ([n (get-neighbors g curr-node)])
         (if (equal? n "out")
             (set! n-paths (add1 n-paths))
             (enqueue-front! q n))
         )
       )

(printf "~v~n" n-paths)