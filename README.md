# gonz

## Usage

### Clone the repo

`git clone https://github.com/GoNZooo/gonz.git`

This will create a folder named `gonz` in the location you have issued the
command in.

### Add the collection to your packages

`raco pkg install --link absolute-path-to-gonz-folder`

raco will install the package information and will refer to this directory when
you use the package.

([Click here](http://docs.racket-lang.org/guide/module-basics.html?q=collections#%28part._link-collection%29) to see alternative ways to add collections.)

### Use the packages

If you want to use the contents of the package you can do the following:

```racket
#lang racket

(require gonz/human-time)
    
(human-time 5m3s) ; 303
```

or

```racket
#lang racket

(require gonz/list-comprehensions)

(<- (- x y) [x '(9 8 7 6)] [y '(1 2 3 4)]) ; '(8 6 4 2)

```

or

```racket
#lang racket

(define episode-list '("S2E1"
                       "S2E2"
                       "S2E3"
                       "S2E4"
                       "S2E5"))
  
(map (lambda (episode-string)
      (with-matches
         #px"S(\\d)E(\\d)" episode-string
         (format "S0~aE0~a"
                 (m 1) (m 2))))
     episode-list) ;; => '("S02E01" "S02E02" "S02E03" "S02E04" "S02E05")
```
