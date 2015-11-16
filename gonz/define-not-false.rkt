#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse)
         racket/bool)

(provide define!?)

(define-syntax (define!? stx)
  (syntax-parse stx
    [(_ bind-id:id sexpr:expr true-expr:expr false-expr:expr)
     #'(begin
         (define bind-id sexpr)
         (if (not (false? bind-id))
           (set! bind-id (true-expr bind-id))
           (set! bind-id false-expr)))]))

