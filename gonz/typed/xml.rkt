#lang typed/racket/base

(require/typed/provide
  xml
  [#:struct location ([line : (U False
                                 Exact-Nonnegative-Integer)]
                      [char : (U False
                                 Exact-Nonnegative-Integer)]
                      [offset : Exact-Nonnegative-Integer])]
  [#:struct source ([start : location]
                    [stop : location])]
  [#:struct external-dtd ([system : String])]
  [#:struct (external-dtd/public external-dtd)
   ([public : String])]
  [#:struct (external-dtd/system external-dtd) ()]
  [#:struct document-type ([name : Symbol]
                           [external : external-dtd]
                           [inlined : False])]
  [#:struct comment ([text : String])]
  [#:struct (p-i source) ([target-name : Symbol]
                          [instruction : String])]
  [#:opaque misc misc/c]
  [#:struct prolog ([misc : (Listof misc)]
                    [dtd : (U document-type False)]
                    [misc2 : (Listof misc)])]
  [#:struct (attribute source) ([name : Symbol]
                                [value : String])]
  [#:opaque Valid-Char valid-char?]
  [#:struct (pcdata source) ([string : String])]
  [#:struct (cdata source) ([string : String])]
  [#:struct (entity source) ([text : String])]
  [#:struct (element source) ([name : Symbol]
                              [attributes : (Listof attribute)]
                              [content : (Listof Content)])]
  [#:struct document ([prolog : prolog]
                      [element : element]
                      [misc : misc])]
  [#:opaque exn:invalid-xexpr exn:invalid-xexpr?]
  [#:opaque Xexpr xexpr?]
  [read-xml (->* () (Input-Port) document)]
  [read-xml/document (->* () (Input-Port) document)]
  [read-xml/element (->* () (Input-Port) element)]
  [write-xml (->* (document) (Output-Port) Void)]
  [write-xml/content (->* (Content) (Output-Port) Void)]
  [display-xml (->* (document) (Output-Port) Void)]
  [display-xml/content (->* (Content) (Output-Port) Void)]
  [write-xexpr (->* (Xexpr) (Output-Port #:insert-newlines? Any) Void)]
  [xml->xexpr (-> Content Xexpr)]
  [xexpr->xml (-> Xexpr Content)]
  [xexpr->string (-> Xexpr String)]
  [string->xexpr (-> String Xexpr)]
  [validate-xexpr (-> Any Boolean)]
  [correct-xexpr? (-> Any (-> Any) (-> exn:invalid-xexpr Any) Any)])

(provide Content)
(define-type Content (U pcdata element entity comment cdata p-i))
