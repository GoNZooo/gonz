#lang racket/base

(provide define/tc
         define/tc/module
         define/tc/hijack
         define/tc/lift

         %test-list%
         
         (except-out (all-from-out racket/base)
                     #%module-begin)
         (rename-out [module-begin #%module-begin])

         (all-from-out rackunit
                       racket/contract))

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse
                     racket/contract)
         rackunit
         racket/contract)

(define %test-list% (list))

(define (add-test function input output)
  (set! %test-list% (append %test-list%
                            (list (list function input output)))))

(define (%run-test% t)
  (check-equal? (apply (car t) (cadr t)) (caddr t)))

(define-syntax-rule (module-begin e ...)
  (#%module-begin
   e ...
   (module+ test
     (for-each %run-test% %test-list%))))

;;; Macro for defining with contract and tests at the same time
;;; Usage is illustrated below.
(define-syntax (define/tc stx)
  (syntax-parse stx
    [(tc (func-name:id arg ...)
         contract-spec
         ([(test-input:expr ...) desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
           (check-equal? (func-name test-input ...) desired-result)
           ...)]
    [(tc (func-name:id arg ...)
         contract-spec
         ([test-input:expr desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
           (check-equal? (func-name test-input) desired-result)
           ...)]))

(define-syntax (define/tc/module stx)
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

(define-syntax (define/tc/hijack stx)
  (syntax-parse stx
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([(test-input:expr ...) desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
         (for-each (lambda (t)
                     (add-test func-name (car t) (cdr t)))
                   (list (cons (list test-input ...)
                               desired-result)
                         ...)))]))

(define-syntax (define/tc/lift stx)
  (syntax-parse stx
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([(test-input:expr ...) desired-result:expr] ...)
         body:expr ...)
     (syntax-local-lift-module-end-declaration
      #'(module+ test
          (check-equal? (func-name test-input ...) desired-result)
          ...))
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...))]))
           
(module+ main
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

    (+ (expt x 2) (expt y 2))))
