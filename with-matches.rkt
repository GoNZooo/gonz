#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

;; The following macro allows you to do submatching against a string
;; using regexp/pregexp and automatically have submatches available
;; through (m <submatch-number>) like so:
;;
;;     (with-matches #px"(\\d) tests (\\w+)" "4 tests passed"
;;       (format "~a: ~a" (m 2) (m 1)))
;;     => "passed: 4"
;;
;; It can be described as follows:
;; (with-matches <regexp with N submatches>
;;               <string to match against>
;;   <body using (m N) to refer to submatches> ...)
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
             "s is not regexp/pregexp literal or id"))
  (syntax-parse stx
    [(_ rxpattern:expr instring:expr
        body:expr ...)
     (with-syntax ([match-recall-id (format-id stx
                                               "~a"
                                               'm)]
                   [internal-match-list '*internal-match-list*])
       #'(cond
            [(not (string? instring))
             (raise-syntax-error 'instring-not-string
                                 "Needs string to search in"
                                 #'with-matches
                                 #'instring)]
            [(not (or (pregexp? rxpattern)
                      (regexp? rxpattern)))
             (raise-syntax-error 'not-regexp-or-string
                                 "Needs regexp or pregexp"
                                 #'with-matches
                                 #'rxpattern)]
            [else
              (let* ([internal-match-list (regexp-match rxpattern instring)]
                     [match-recall-id
                       (lambda (n)
                         (if (>= n
                                 (length internal-match-list))
                           (raise-syntax-error 'sub-match-index
                                               "Sub-match index needs to match number of submatches in regular expression"
                                               #'with-matches
                                               #'match-recall-id)
                           (list-ref internal-match-list n)))])
                body ...)]))]))

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
