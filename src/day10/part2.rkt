#lang rosette

(require data/collection list-util)
(require rosette/solver/smt/z3)


;; Define the solver
(current-solver (z3))

(define (solve-machine buttons target-joltages)
  ;; IMPORTANT: Clear previous constraints so they don't persist
  (clear-vc!)
  
  ;; 1. Define symbolic variables for each button press
  (define button-presses 
    (for/list ([i (length buttons)])
      (define-symbolic* b integer?)
      b)
    )

  ;; 2. Physical constraints: Presses must be non-negative integers
  (for ([b button-presses])
    (assert (>= b 0))
    )

  ;; 3. Linear equations: light_j = sum(presses of buttons affecting light j)
  (for ([target-j target-joltages] [light-idx (in-naturals)])
    (define current-light-joltage
      (for/fold ([sum 0])
                ([btn-schema buttons] [presses button-presses])
        (if (member light-idx btn-schema)
            (+ sum presses)
            sum)
        )
      )
    (assert (= current-light-joltage target-j))
    )

  ;; 4. Optimization: Minimize the total count of button presses
  (define total-presses 
    (for/fold ([sum 0]) ([p button-presses]) (+ sum p))
    )
  
  ;; Use Rosette's optimize to find the minimal integer combination
  (define solution (optimize #:minimize (list total-presses) 
                             #:guarantee (assert #t))
    )

  (if (sat? solution)
      (evaluate total-presses solution)
      #f)
  )

(define DAY_INPUT "../../input/day10/input.txt")

(define lines (file->lines DAY_INPUT))

(define answer 0)

(for ([line lines])
  ; [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}

  (define fields (string-split line " "))
  (define indicator (first fields))  ; not used in part 2
  (define buttons (for/list ([l (for/list ([b (drop-right (rest fields) 1)]) (regexp-replace* #px"[()]" b ""))]) (for/list ([s (string-split l ",")]) (string->number s))))
  (define joltage (sequence->list (map string->number (string-split (regexp-replace* #px"[{}]" (last fields) "") ","))))

  #|

  Linear programming problem:

  For each button b1 ... bn

  Find solutions for x1 * b1 + x2 * b2 + x3 * b3 ... + xn * bn == joltage

  each x must be an integer >=0

  Solve for minimum presses i.e. minimum sum of x

  (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}

  b b b b b b
  1 2 3 4 5 6   j

  0 0 0 0 1 1   3
  0 1 0 0 0 1   5
  0 0 1 1 1 0   4
  1 1 0 1 0 0   7

  x x x x x x
  1 2 3 4 5 6

  x5 * b5 + x6 * b6           = 3
  x2 * b2 + x6 * b6           = 5
  x3 * b3 + x4 * b4 + x5 * b5 = 4
  x1 * b1 + x2 * b2 + x4 * b4 = 7

  |#

  ; using the Z3 solver in rosette
  (let ([ans (solve-machine buttons joltage)])
    (when ans
      (set! answer (+ answer ans))
      )
    )
  )

(printf "Answer: ~v~n" answer)