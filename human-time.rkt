#lang racket/base

(require (for-syntax racket/base
                     racket/bool
                     syntax/parse))

(provide human-time)

; Macro to translate human-readabale times into seconds.
; Usage example:
;   (human-time 1h) = 3600
;   (human-time 24h30m5s) = 88205
(define-syntax (human-time stx)
  (define (parse-time time-stx)
    (define time-string (symbol->string (syntax->datum time-stx)))
    
    (define (get-hours t)
      (let ([r (regexp-match #px"(\\d*)[Hh]" t)])
        (if (false? r)
            0
            (string->number (list-ref r 1)))))
    
    (define (get-minutes t)
      (let ([r (regexp-match #px"(\\d*)[Mm]" t)])
        (if (false? r)
            0
            (string->number (list-ref r 1)))))
    
    (define (get-seconds t)
      (let ([r (regexp-match #px"(\\d*)[Ss]" t)])
        (if (false? r)
            0
            (string->number (list-ref r 1)))))

    (+ (* (get-hours time-string) 3600)
       (* (get-minutes time-string) 60)
       (get-seconds time-string)))
    
  (syntax-parse stx
    [(ht time:id)
     (with-syntax ([seconds (parse-time #'time)])
       #'seconds)]))

(module+ main
  (human-time 1h)
  (human-time 24h30m5s))