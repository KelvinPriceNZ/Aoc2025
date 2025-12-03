#lang racket

(require while-until)

(define (process-file filename)
  (call-with-input-file filename
    (lambda (port)
      (define position 50)
      (define password 0)
      (let loop ()
        (define line (read-line port 'any))
        (unless (eof-object? line)
          (define direction (string-ref line 0))
          (define amount (string->number (substring line 1)))
          (if (char=? direction #\R)
              (set! position (+ position amount))
              (set! position (- position amount))
              )
          (if (negative? position)
              ( while (negative? position) (set! position (+ position 100)))
              ( void))
          (set! position (modulo position 100))
          (if (equal? position 0) (set! password (add1 password)) (void))
          (loop)))
      (printf "Password ~a~n" password)
      )))


(process-file "../../input/day01/input.txt")