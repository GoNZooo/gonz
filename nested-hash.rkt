#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide hash-ref*)

; (hash-ref h 'foo 'bar) => (hash-ref (hash-ref h 'foo) 'bar)

(define (chain-keys h keys)
  (if (null? keys)
    h
    (chain-keys (hash-ref h (car keys))
                (cdr keys))))

(define-syntax (hash-ref* stx)
  (syntax-parse stx
    [(_ hash-object key ...)
     #'(chain-keys hash-object (list key ...))]))

(module+ main
  (define h '#hash((foo . #hash((bar . 10)))))
  
  (hash-ref* h 'foo 'bar))
