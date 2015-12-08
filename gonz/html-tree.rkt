#lang racket/base

(require racket/match
         xml
         html
         net/url)

; (-> string? (listof xexpr?))
(provide url->xexprs)
(define (url->xexprs base-url)
  (map xml->xexpr
       (call/input-url (string->url base-url)
                       get-pure-port
                       read-html-as-xml)))

;; (-> (listof xexpr?) symbol? (listof xexpr?))
(provide find*)
(define (find* root element-type)
  (match root
    ['() '()]
    [(list (list sub-exprs ...) exprs ...)
     (append (find* sub-exprs element-type)
             (find* exprs element-type))]
    [(list expr exprs ...)
     #:when (equal? element-type expr)
     (append `(,(cons expr exprs)) (find* exprs element-type))]
    [(list expr exprs ...)
     (find* exprs element-type)]))

(module+ main
  (require racket/pretty)
  (define page-xexpr (url->xexprs "http://severnatazvezda.com/github/"))
  (pretty-print 
   ;; Finds all links on a page
   (find* page-xexpr
          'a))
  (pretty-print (xexpr? (car page-xexpr))))
;; Finds all divs on a page
;(pretty-print 
;  (find* page-xexpr
;         'div)))
  ;;; Finds all hrefs on a page
;(pretty-print
;  (find* page-xexpr
;         'href)))
