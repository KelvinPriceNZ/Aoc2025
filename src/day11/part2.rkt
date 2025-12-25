#lang racket

(require graph)
(require memo)

(define DAY_INPUT "../../input/day11/input.txt")

(define lines (file->lines DAY_INPUT))

(define g (unweighted-graph/directed '()))

(add-vertex! g "out")

(for ([line lines])
  (define nodes (string-split line " "))
  (define src (regexp-replace #rx":$" (first nodes) ""))
  (add-vertex! g src)
  )

(for ([line lines])
  (define nodes (string-split line " "))
  (define src (regexp-replace #rx":$" (first nodes) ""))
  (for ([edge (cdr nodes)])
    (add-directed-edge! g src edge)
    )
  )

(define/memoize (num-paths g src dst)
  (if (equal? src dst)
      1
      (apply + (map (λ (n) (num-paths g n dst)) (get-neighbors g src)))
      )
  )

(+
 (*
  (num-paths g "svr" "dac")
  (num-paths g "dac" "fft")
  (num-paths g "fft" "out")
  )
 (*
  (num-paths g "svr" "fft")
  (num-paths g "fft" "dac")
  (num-paths g "dac" "out")
  )
 )