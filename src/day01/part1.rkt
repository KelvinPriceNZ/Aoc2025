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
          (printf "~a Pos ~a Dir ~a Amount ~a" line position direction amount)
          (if (char=? direction #\R)
              (set! position (+ position amount))
              (set! position (- position amount))
              )
          (if (negative? position)
              ( while (negative? position) (set! position (+ position 100)))
              ( void))
          (set! position (modulo position 100))
          (printf " pos: ~a~n" position)
          (if (equal? position 0) (set! password (add1 password)) (void))
          (loop)))
      (printf "Password ~a~n" password)
      )))


(process-file "../../input/01/input.txt")