#lang racket/base

(require racket/match
		 racket/port
		 net/url
		 xml
		 html)

(provide url->xexprs
		 find*)

(permissive-xexprs #t)

(define (url->xexprs base-url)
  (map xml->xexpr
	   (call/input-url (string->url base-url)
					   get-pure-port
					   read-html-as-xml)))

(define (find* root element-type)
  (match root
	['() '()]
	[(list (list sub-exprs ...) exprs ...)
	 (append (find* sub-exprs element-type)
			 (find* exprs element-type))]
	[(list expr exprs ...)
	 #:when (equal? element-type expr)
	 (append `((,expr ,exprs)) (find* exprs element-type))]
	[(list expr exprs ...)
	 (find* exprs element-type)]))

