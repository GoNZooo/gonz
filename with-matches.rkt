#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide (for-syntax with-matches))
(define-syntax (with-matches stx)
  (define-syntax-class
    str-lit-or-id
    #:description "string literal or id for string"
    (pattern s
             #:fail-unless
             (string? (syntax-e #'s))
             "s is not string literal/id"))
  (syntax-parse stx
    [(_ rxpattern:str-lit-or-id instring:str-lit-or-id
       body:expr ...)
     (with-syntax ([match-recall-id 'm#]
                   [internal-match-list '*internal-match-list*]))
     #'(begin
         (define internal-match-list)
         (define (match-recall-id n)
           (list-ref internal-match-list n))
         body ...)]))
