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
          (printf "~a Pos ~a Dir ~a Amount ~a Password ~a" line position direction amount password)
          (define inc 0)
          (if (char=? direction #\R)
              (set! inc 1)
              (set! inc -1)
              )
          (for ([i (in-range 1 (add1 amount))])
            (begin
              (set! position (+ position inc))
              (set! position (modulo position 100))
              (when (zero? position)
                (set! password (add1 password)))
              ))
          (printf " pos: ~a   password: ~a~n" position password)
          (loop)))
      (printf "Password ~a~n" password)
      )))


(process-file "../../input/01/input.txt")