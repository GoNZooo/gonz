#lang scribble/doc

@(require (for-label racket/base
                     racket/contract)
          scribble/manual
          scribble/basic
          scribble/eval)

@(define ht-eval (make-base-eval))
@(interaction-eval #:eval ht-eval (require "human-time.rkt"))
@title{human-time}
@defproc[(human-time [time-spec string?]) integer?]{
Returns the time specified with @racket[time-spec] in seconds.
}

@(examples #:eval ht-eval
           (human-time "24h30m5s")
           (human-time "1h")
           (human-time "1337m"))
