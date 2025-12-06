#lang racket

(define (badnum? n)
  (define num (number->string n))
  (define l (string-length num))
  (cond
    [(odd? l) #f]
    [(even? l) (equal? (substring num 0 (/ l 2)) (substring num (/ l 2) l))]
    )
  )


(define DAY_INPUT "../../input/day02/input.txt")

(define lines (file->lines DAY_INPUT))

(define solution 0)

(for ([line lines])
  (define ranges (string-split line ","))
  (for ([myrange ranges])
    (match-define (list first second) (string-split myrange "-"))
    (for ([n (in-range (string->number first) (add1 (string->number second)))])
      (when (badnum? n)
        (set! solution (+ solution n)))
      )
    )
  )

(printf "Answer: ~v~n" solution)