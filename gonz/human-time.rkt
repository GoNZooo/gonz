#lang racket/base

(provide human-time)

; Macro to translate human-readabale times into seconds.
; Usage example:
;    = 3600
;    = 88205
(define (human-time time-spec)
  (define (parse-time)
    (define (get-hours)
      (let ([r (regexp-match #px"(\\d*)[Hh]" time-spec)])
        (if (not r)
          0
          (string->number (list-ref r 1)))))

    (define (get-minutes)
      (let ([r (regexp-match #px"(\\d*)[Mm]" time-spec)])
        (if (not r)
          0
          (string->number (list-ref r 1)))))

    (define (get-seconds)
      (let ([r (regexp-match #px"(\\d*)[Ss]" time-spec)])
        (if (not r)
          0
          (string->number (list-ref r 1)))))

    (+ (* (get-hours) 3600)
       (* (get-minutes) 60)
       (get-seconds)))

  (parse-time))

(module+ main
  (human-time "1h")
  (human-time "24h30m5s"))
