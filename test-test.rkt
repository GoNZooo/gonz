#lang racket/base

(require gonz/define-test)

(define/tc/lift (square2&add x y)
  (integer? integer? . -> . integer?)
  ([(2 3) 13]
   [(1 2) 5])
  
  (define/tc/lift (square x)
    (integer? . -> . integer?)
    ([(5) 25]
     [(6) 36])

    (expt x 2))
  
   (+ (expt x 2) (expt y 2)))
