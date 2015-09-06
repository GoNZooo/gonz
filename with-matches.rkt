#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide with-matches)
(define-syntax (with-matches stx)
  (define-syntax-class
    str-lit
    #:description "string literal"
    (pattern s
             #:fail-unless
             (or (string? (syntax-e #'s))
                 (symbol? (syntax-e #'s)))
             "s is not string literal"))
  (syntax-parse stx
    [(_ rxpattern:str-lit instring:str-lit
        body:expr ...)
     (with-syntax ([match-recall-id (format-id stx
                                               "~a"
                                               'm#)]
                   [internal-match-list '*internal-match-list*])
       #'(begin
           (define internal-match-list (regexp-match rxpattern instring))
           (define (match-recall-id n)
             (list-ref internal-match-list n))
           body ...))]))
