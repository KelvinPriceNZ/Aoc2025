#lang racket

(require data/collection data/queue while-until)

(define DAY_INPUT "../../input/day10/input.txt")

(define lines (file->lines DAY_INPUT))

(define answer 0)

(define (list->binary-string l n)
  (define b (make-string n #\0 ))
  (for ([i l])
    (string-set! b i #\1)
    )
  (string->number b 2)
  )

(for ([line lines])
  ; [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  ;
  ; convert things to strings of binary, then to numbers
  (define fields (string-split line " "))
  (define indicator (string->number (regexp-replace* #rx"#" (regexp-replace* #rx"\\." (regexp-replace* #px"[\\[\\]]" (first fields) "") "0") "1") 2))
  (define buttons (sort (remove-duplicates (stream->list (map (λ (x) (list->binary-string x (- (length (first fields)) 2))) (for/list ([l (for/list ([b (drop-right (rest fields) 1)]) (regexp-replace* #px"[()]" b ""))]) (for/list ([s (string-split l ",")]) (string->number s)))))) <))
  (define joltage (regexp-replace* #px"[{}]" (last fields) ""))

  (define q (make-queue))
  (define val 0)
  (define depth 1)
  (define btns buttons)
  (enqueue! q (list 0 1 buttons))

  ; bfs sequence of xor
  (while (non-empty-queue? q)
         (set!-values (val depth btns) (apply values (dequeue! q)))
         (for ([btn btns])
           (define new-val (bitwise-xor val btn))
           (if (equal? new-val indicator)
               (begin
                 (set! answer (+ answer depth))
                 (break)
                 )
               ; else ...
               (enqueue! q (list new-val (add1 depth) (remove btn btns)))
               )
           )
         )
  )

(printf "Answer: ~v~n" answer)
