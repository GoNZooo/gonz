#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse)
         racket/list)

; List comprehension wrapper (around for/list) with Haskell-like syntax
;
; Reference:
;  [x | x <- generator]
;  [x | x <- generator, predicate]
(define-syntax (<- stx)
  
  (syntax-parse stx
    [(lc computation:expr [bind:id generator:expr] ...)
     #'(for/list ([bind generator] ...)
         computation)]
    [(lc computation:expr ([bind:id generator:expr] ...) predicate:expr)
     #'(for/list ([bind generator] ...
                  #:when predicate)
         computation)]))

(module+ main
  (<- (+ x y)
      [x '(1 3 3 7)]
      [y '(7 3 3 1)])

  (<- (+ x y 1)
      ([x '(1 2 3 4)]
       [y '(5 3 2 1)])
      (or (< x 2) (> x 3))))
      
    