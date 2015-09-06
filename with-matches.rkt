#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide with-matches)
(define-syntax (with-matches stx)
  (define-syntax-class
    regexplit
    #:description "regexp/pregexp literal or id"
    (pattern s
             #:fail-unless
             (or (string? (syntax-e #'s))
                 (symbol? (syntax-e #'s))
                 (pregexp? (syntax-e #'s))
                 (regexp? (syntax-e #'s)))
             "s is not string literal"))
  (syntax-parse stx
    [(_ rxpattern:regexplit instring:regexplit
        body:expr ...)
     (with-syntax ([match-recall-id (format-id stx
                                               "~a"
                                               'm)]
                   [internal-match-list '*internal-match-list*])
       #'(let* ([internal-match-list (regexp-match rxpattern instring)]
                [match-recall-id
                  (lambda (n)
                    (list-ref internal-match-list n))])
           body ...))]))

(module+ test
  (require rackunit)

  (define episode-list '("S2E1"
                         "S2E2"
                         "S2E3"
                         "S2E4"
                         "S2E5"))
  
  (check-equal?
    (map (lambda (episode-string)
           (with-matches
             #px"S(\\d)E(\\d)" episode-string
             (format "S0~aE0~a"
                     (m 1) (m 2))))
         episode-list)
  '("S02E01" "S02E02" "S02E03" "S02E04" "S02E05")
  "Test using pregexp-literal failed")

  (define pregexp-binding (pregexp "S(\\d)E(\\d)"))
  (check-equal?
    (map (lambda (episode-string)
           (with-matches
             pregexp-binding episode-string
             (format "S0~aE0~a"
                     (m 1) (m 2))))
         episode-list)
  '("S02E01" "S02E02" "S02E03" "S02E04" "S02E05")
  "Test using pregexp-binding failed")

  (check-equal?
    (map (lambda (episode-string)
           (with-matches
             #rx"S([0-9])E([0-9])" episode-string
             (format "S0~aE0~a"
                     (m 1) (m 2))))
         episode-list)
  '("S02E01" "S02E02" "S02E03" "S02E04" "S02E05")
  "Test using regexp-literal failed")

  (define regexp-binding (regexp "S([0-9])E([0-9])"))
  (check-equal?
    (map (lambda (episode-string)
           (with-matches
             pregexp-binding episode-string
             (format "S0~aE0~a"
                     (m 1) (m 2))))
         episode-list)
  '("S02E01" "S02E02" "S02E03" "S02E04" "S02E05")
  "Test using regexp-binding failed")
  )
