#lang racket/base

(require racket/match
         racket/contract
         racket/port)

(define/contract (module->exported-functions/pattern module-name)
  (symbol? . -> . (listof symbol?))

  (dynamic-require module-name #f)

  (define-values (m1 m2)
    (module->exports module-name))

  (define (extract-ids entries [output '()])
    (match entries
      ['() output]
      [(list (list (? number?)
                   subentries ...)
             next-entries ...)
       (append (extract-ids subentries)
               (extract-ids next-entries))]
      [(list (list exported-id _ ...)
             es ...)
       (extract-ids es
                    (cons exported-id
                          output))]))

  (append (extract-ids m1)
          (extract-ids m2)))

(define/contract (subset small big [output '()])
  ((list? list?) (list?) . ->* . list?)

  (define (mirrored?)
    (findf (lambda (item)
             (equal? (car small)
                     item))
           big))

  (cond
    [(null? small) output]
    [(> (length small) (length big))
     (subset big small)]
    [(mirrored?)
     (subset (cdr small)
             big
             (cons (car small)
                   output))]
    [else
     (subset (cdr small)
             big
             output)]))

(module+ main
  (require racket/pretty)
  (define r (module->exported-functions/pattern 'racket))
  (define rbase (module->exported-functions/pattern 'racket/base))
  (define neturl (module->exported-functions/pattern 'net/url))
  (define racketport (module->exported-functions/pattern 'racket/port))
  (pretty-print (subset racketport r))
  (pretty-print racketport)
  )
