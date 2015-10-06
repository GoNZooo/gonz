#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide doto)
(define-syntax (doto stx)
  (syntax-parse stx
    [(_ init func ...)
     #'(foldl (lambda (f res)
                (f res))
              init
              `(,func ...))]))
