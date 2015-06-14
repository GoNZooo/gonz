#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))

(provide while
         until)

;;; Macro for while-loops.
(define-syntax (while stx)
  (syntax-parse stx 
    [(_ condition:expr body:expr ...)
     #'(letrec ([loop
                  (lambda ()
                    (when condition
                      body
                      ...
                      (loop)))])
         (loop))]))

;;; Macro for until-loops.
(define-syntax (until stx)
  (syntax-parse stx
    [(_ condition:expr body:expr ...)
     #'(letrec ([loop
                  (lambda ()
                    (unless condition
                      body
                      ...
                      (loop)))])
         (loop))]))
