#lang racket
(require helpful)
(define (badnum? n)
  (define num (number->string n))
  (define l (string-length num))
  (define g #f)
  (for ([p (in-range 1 (add1 (quotient l 2)))])
    #:break (equal? g #t)
    (define patt (pregexp (string-append "^(?:" (substring num 0 p) "){" (number->string (floor (/ l p))) "}$")))
    (when (regexp-match? patt num)
      (set! g #t)
      )
    )
  g
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