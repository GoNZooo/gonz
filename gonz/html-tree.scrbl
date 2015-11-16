#lang scribble/doc

@(require (for-label racket
                     xml/xexpr
                     racket/contract)
          scribble/manual
          scribble/basic
          scribble/eval)

@(define ht-eval (make-base-eval))
@(interaction-eval #:eval ht-eval (require "html-tree.rkt"))

@title{html-tree}
This module includes two functions, @secref["url-_xexprs"] and @secref["find_"].
They are used together to extract tags from HTML pages.
@section{url->xexprs}
@defproc[(url->xexprs [url string?]) (listof xexpr?)]{
Returns a list of @racket[xexpr?] after fetching the requested @racket[url]
}

@section{find*}
@defproc[(find* [xexprs (listof xexpr?)] [tag symbol?]) (listof xexpr?)]{
Returns a list of @racket[xexpr?] after filtering out all items in @racket[xexprs]
that match @racket[tag]. The function is recursive, so will drill down as far as
it can to match all items in every sub-xexpr.
}
