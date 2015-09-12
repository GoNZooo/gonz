#lang racket/base

(provide (all-from-out rackunit
                       racket/contract))

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse
                     racket/contract)
         rackunit
         racket/contract)

;;; Macro for defining with contract and tests at the same time
;;; Usage is illustrated below.
(provide define/tc)
(define-syntax (define/tc stx)
  (syntax-parse stx
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([(test-input:expr ...) desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
         (module+ test
           (check-equal? (func-name test-input ...) desired-result)
           ...))]
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([test-input:expr desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
         (module+ test
           (check-equal? (func-name test-input) desired-result) ...))]))

(define/tc (square x)
  (integer? . -> . integer?)

  ([2 4]
   [3 9]
   [5 25])

  (expt x 2))

(define/tc (square2&add x y)
  (integer? integer? . -> . integer?)

  ([(2 3) 13]
   [(1 2) 5])

  (+ (expt x 2) (expt y 2)))
