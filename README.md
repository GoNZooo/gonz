# gonz

## Usage

### Clone the repo

`git clone https://github.com/GoNZooo/gonz.git`

This will create a folder named `gonz` in the location you have issued the command in.

### Add the collection to your packages

`raco pkg install --link ./gonz`

raco will install the package information and will refer to this directory when you use the package

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
