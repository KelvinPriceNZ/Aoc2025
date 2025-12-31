#lang racket

(define DAY_INPUT "../../input/day12/input.txt")

(define stanzas (string-split (file->string DAY_INPUT) "\n\n"))

(define regions (last stanzas))

(define tile_shapes (drop-right stanzas 1))

(define tile_sizes '())

(for ([tile tile_shapes])
  (define l 0)
  (for ([c (string->list tile)])
    (when (char=? c #\#) (set! l (add1 l)))
    )
  (set! tile_sizes (append tile_sizes (list l)))
  )

(define answer 0)

(for ([region (string-split regions "\n")])
  (define fields (regexp-match* #px"(\\d+)" region))
  (define-values (width length) (apply values (map string->number (take fields 2))))
  (define tile_counts (map string->number (drop fields 2)))

  (define region_area (* width length))
  (define region_tiles (* (quotient width 3) (quotient length 3)))
  (define total_tiles (apply + tile_counts))
  (define perfect_cover (apply + (map * tile_counts tile_sizes)))

  (cond
    ; Can I cover the area with just the 3x3 tiles ?
    [(<= total_tiles region_tiles) (set! answer (add1 answer))] ; yes, so count it as tileable
    ; assuming perfect coverage (which won't be possible) is the region area big enough ?
    [(> perfect_cover region_area) (void)]; no, so not tileable at all
    ; if neither of the above, then we'll need to get clever
    ; or add another heuristic e.g. the chessboard test
    [else (displayln "Have to do something clever here")        ]
    )
  )

(printf "Answer: ~v~n" answer)

#|

Ha ha ha (or Ho ho ho ?)
   
Turned out I didn't need to do the "something clever"

|#