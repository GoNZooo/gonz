#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide hash-ref*)

; (hash-ref h 'foo 'bar) => (hash-ref (hash-ref h 'foo) 'bar)

(define (chain-keys h keys [fail? 'no-fail])
  (cond
    [(null? keys) h]
    [(equal? fail? 'no-fail)
     (chain-keys (hash-ref h (car keys))
                 (cdr keys)
                 fail?)]
    [(not (hash-has-key? h (car keys)))
     fail?]
    [else
      (chain-keys (hash-ref h (car keys) fail?)
                  (cdr keys)
                  fail?)]))

(define-syntax (hash-ref* stx)
  (syntax-parse stx
    [(_ hash-object key:expr ...)
     #`(chain-keys hash-object (list key ...))]
    [(_ hash-object key:expr ... #:fail? fail-expr:expr)
     #`(chain-keys hash-object (list key ...) fail-expr)]))

(module+ main
  (define h '#hash((foo . #hash((bar . 10)))))
  
  (hash-ref* h 'foo 'baar 'baz #:fail? 'fail-symbol))
