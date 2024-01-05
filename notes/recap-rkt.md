# Recap racket/scheme

## List vs cons
Couldn't figure out how to concat an element with a list, as cons "flattens" the list.
```
(list 1 2 '(3))
> '(1 2 (3))
(cons 1 '(2))
> '(1 2) ; careful! This only works by putting the value first and the list second!
```
