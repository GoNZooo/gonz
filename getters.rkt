#lang racket/base

(require (for-syntax racket/base
                     racket/syntax))

(define-syntax (define/getters stx)

  (define (make-ids base subs)
    (map (lambda (s)
           (format-id base
                      "~a-~a"
                      base
                      s))
         subs))

  (define (enumerate lst [index 0] [output '()])
    (if (null? lst)
        (reverse output)
        (enumerate (cdr lst)
                   (+ index 1)
                   (cons index
                         output))))
  
  (syntax-case stx ()
    [(_ sbase (ssub ...))
     (with-syntax* ([(id ...)
                     (make-ids #'sbase (syntax->datum #'(ssub ...)))]
                    [(index ...)
                     (enumerate (syntax->datum #'(id ...)))])
                   #'(begin
                       (define (id obj)
                         (list-ref obj index))
                       ...))]
    [(_ sbase (ssub ...) sindex)
     (with-syntax* ([(id ...)
                     (make-ids #'sbase (syntax->datum #'(ssub ...)))]
                    [(index ...)
                     (enumerate (syntax->datum #'(id ...))
                                (syntax->datum #'sindex))])
                   #'(begin
                       (define (id obj)
                         (list-ref obj index)) ...))]))
  
(module+ main
  (define data '(1 2 3 4 5))
  
  (define/getters type (one two))
  (type-one data)
  (type-two data)

  (define/getters type (three four five) 2)
  
  (type-three data)
  (type-four data)
  (type-five data))
