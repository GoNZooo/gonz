#lang typed/racket/base

(require gonz/typed/xml)

(require/typed/provide
  gonz/html-tree
  [url->xexprs (-> String (U Xexpr (Listof Xexpr)))]
  [find* (-> (U Null (U Xexpr (Listof Xexpr))) Symbol (Listof Xexpr))])

(module+ main
  (find* (url->xexprs "http://severnatazvezda.com/github/") 'a))
