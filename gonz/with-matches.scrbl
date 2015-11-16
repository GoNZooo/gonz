#lang scribble/doc

@(require (for-label racket/base)
          scribble/manual
          scribble/basic
          scribble/eval)

@(provide doc)

@(define wm-eval (make-base-eval))
@(interaction-eval #:eval wm-eval (require "with-matches.rkt"))

@title{with-matches}
@defform[(with-matches rxpattern instring body ...)
         #:contracts
         ([rxpattern (or/c pregexp? regexp?)]
          [instring string?]
          [body (listof any/c)])]
Automatically binds every submatch in expression to be used with
(m N) where N is the number of the match, starting at 1.

@(interaction-eval #:eval wm-eval (require "with-matches.rkt"))
@examples[#:eval wm-eval
          (with-matches #px"S(\\d{2})E(\\d{2})"
                        "S03E05"
                        (printf "Season: ~a~nEpisode: ~a~n"
                                (m 1) (m 2)))]
