#lang racket/gui

;; This file contains a set of macros that make writing
;; GUI stuff faster. It obscures parts of the code that in
;; general would be good for readability as a cost of writability.

(provide event-equal?
         msg
         hpanel
         vpanel
         tfield
         btn
         lbox)

(require (for-syntax racket/syntax))

(define-syntax (btn stx)
  (syntax-case stx ()
	[(_ sname sparent slabel scallback opt ...)
	 (with-syntax ([name (format-id stx
									"~a"
									(syntax->datum #'sname))])
	   #'(define name (new button% [parent sparent]
						   [label slabel]
						   [callback scallback]
						   opt ...)))]))

(define-syntax (tfield stx)
  (syntax-case stx ()
	[(_ sname sparent slabel scallback)
	 (with-syntax ([name (format-id stx
									"~a"
									(syntax->datum #'sname))])
	   #'(define name (new text-field% [parent sparent]
						   [label slabel]
						   [callback scallback]
						   [style '(single vertical-label)])))]
	[(_ sname sparent slabel scallback opt ...)
	 (with-syntax ([name (format-id stx
									"~a"
									(syntax->datum #'sname))])
	   #'(define name (new text-field% [parent sparent]
						   [label slabel]
						   [callback scallback]
						   opt ...)))]))

(define-syntax (msg stx)
  (syntax-case stx ()
	[(_ sname sparent slabel opt ...)
	 (with-syntax ([name-sym (format-id stx
										"~a"
										(syntax->datum #'sname))])
	   #'(define name-sym (new message% [parent sparent]
							   [label slabel]
							   opt ...)))]))

; hpanel macro with options
(define-syntax (hpanel stx)
  (syntax-case stx ()
	[(_ sname sparent opt ...)
	 (with-syntax ([name-sym (format-id stx
										"~a"
										(syntax->datum #'sname))])
	   #'(define name-sym (new horizontal-panel% [parent sparent]
							   opt ...)))]))

(define-syntax (vpanel stx)
  (syntax-case stx ()
	[(_ sname sparent opt ...)
	 (with-syntax ([name-sym (format-id stx
										"~a"
										(syntax->datum #'sname))])
	   #'(define name-sym (new vertical-panel% [parent sparent]
							   opt ...)))]))

(define-syntax (lbox stx)
  (syntax-case stx ()
	[(_ sname sparent slabel sdata scallback opt ...)
	 (with-syntax ([name-sym (format-id stx
										"~a"
										(syntax->datum #'sname))])
	   #'(begin
		   (define name-sym (new list-box% [parent sparent]
								 [label slabel]
								 [choices '()]
								 [callback scallback]
								 opt ...))))]))

(define (event-equal? event type)
  (equal? (send event get-event-type) type))
