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
                 (symbol? (syntax-e #'s))
                 (pregexp? (syntax-e #'s))
                 (regexp? (syntax-e #'s)))
             "s is not string literal"))
  (syntax-parse stx
    [(_ rxpattern:str-lit instring:str-lit
        body:expr ...)
     (with-syntax ([match-recall-id (format-id stx
                                               "~a"
                                               'm#)]
                   [internal-match-list '*internal-match-list*])
       #'(let* ([internal-match-list (regexp-match rxpattern instring)]
                [match-recall-id
                  (lambda (n)
                    (list-ref internal-match-list n))])
           body ...))]))

(module+ main
  (define episode-list '("S2E1"
                         "S2E2"
                         "S2E3"
                         "S2E4"
                         "S2E5"))
  
  (map (lambda (episode-string)
         (with-matches
           #px"S(\\d)E(\\d)" episode-string
           (format "S0~aE0~a"
                   (m# 1) (m# 2))))
       episode-list))
