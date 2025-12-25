#lang racket

(define (inside? pt edges)
  (define-values (px py) (apply values pt))
  (define crosses
    (for/fold ([count 0]) ([edge edges])
      (let* ([p1 (first edge)] [p2 (second edge)]
             [x1 (first p1)]  [y1 (second p1)]
             [x2 (first p2)]  [y2 (second p2)])
        ;; Only consider edges that span the point's Y level
        (if (and (not (= y1 y2)) ; Ignore horizontal edges
                 (or (and (<= y1 py) (< py y2))
                     (and (<= y2 py) (< py y1))))
            ;; Calculate X intersection of the edge with the ray at Y = py
            (let ([x-intersect (+ x1 (* (/ (- py y1) (- y2 y1)) (- x2 x1)))])
              (if (> x-intersect px) (add1 count) count))
            count))))
  (odd? crosses))

(define DAY_INPUT "../../input/day09/input.txt")

(define lines (file->lines DAY_INPUT))

(define red-tiles '())

(for ([line lines])
  (define-values (x y) (apply values (map string->number (string-split line ","))))
  (set! red-tiles (cons (list x y) red-tiles))
  )

(define poly '())

(for ([n (range 1 (length red-tiles))])
  (set! poly (cons (list (list-ref red-tiles (sub1 n)) (list-ref red-tiles n)) poly))
  )
(set! poly (cons (list (last red-tiles) (first red-tiles)) poly))

(define areas '())
(define max-area 0)

(for ([p (combinations red-tiles 2)])
  (define-values (p1 p2) (apply values p))
  (define x-lo (min (first p1) (first p2)))
  (define x-hi (max (first p1) (first p2)))
  (define y-lo (min (second p1) (second p2)))
  (define y-hi (max (second p1) (second p2)))
  (define area (* (+ 1 (- x-hi x-lo)) (+ 1 (- y-hi y-lo))))
  
  (when (> area max-area)
    ;; 1. Check if a representative point (center) is inside the polygon
    (define center (list (/ (+ x-lo x-hi) 2) (/ (+ y-lo y-hi) 2)))
    (when (inside? center poly)
      ;; 2. Ensure NO polygon vertices are strictly inside the rectangle
      (define no-points-inside
        (for/and ([rt red-tiles])
          (let ([rx (first rt)] [ry (second rt)])
            (not (and (> rx x-lo) (< rx x-hi) (> ry y-lo) (< ry y-hi))))))
      
      (when no-points-inside
        ;; 3. Check if any polygon edge intersects the rectangle's boundary
        (define no-edge-crossings
          (for/and ([edge poly])
            (define-values (ep1 ep2) (apply values edge))
            (define ex1 (first ep1)) (define ey1 (second ep1))
            (define ex2 (first ep2)) (define ey2 (second ep2))
            ;; Check if this edge segments across the rectangle
            (not (or (and (= ex1 ex2) (> ex1 x-lo) (< ex1 x-hi) 
                          (not (or (<= (max ey1 ey2) y-lo) (>= (min ey1 ey2) y-hi))))
                     (and (= ey1 ey2) (> ey1 y-lo) (< ey1 y-hi) 
                          (not (or (<= (max ex1 ex2) x-lo) (>= (min ex1 ex2) x-hi))))))))
        
        (when no-edge-crossings
          (set! max-area area)
;          (printf "New max: ~v to ~v Area: ~a~n" p1 p2 area)
          )
        )
      )
    )
  )

(displayln max-area)
