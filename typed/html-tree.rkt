#lang typed/racket/base

(require gonz/typed/xml)

(require/typed/provide
  gonz/html-tree
  [url->xexprs (-> String (Listof Xexpr))]
  [find* (-> (U Null (Listof Xexpr)) Symbol (Listof Xexpr))])

(module+ main
  (find* (url->xexprs "http://severnatazvezda.com/github/") 'a))
