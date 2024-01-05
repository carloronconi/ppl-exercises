# Haskell recap

## As-patterns
```
dequeue :: Queue a -> (Maybe a, Queue a)
dequeue q@(Queue [] []) = (Nothing, q)
dequeue (Queue (x:xs) v) = (Just x, Queue xs v)
dequeue (Queue [] v) = dequeue (Queue (reverse v) [])
```
`q@` is used to pattern match both the whole Queue struct and its internal values.

## Cons and lists
with `elm :: a` and `lst :: [a]`
`elm : lst` and `[elm] ++ lst` do the same thing: pre-pend the element to the list `[elm, lst...]`

## Signatures when instancing type classes Show, Eq vs Functor, Foldable, Applivative
`data Fpair s a = Pair a a | Fpair a a s`
The classes Show, Eq VS Functor, Foldable, Applicative need different type constructors:

### Show and Eq: no parameters
Show, Eq need non-parametrized types, so by writing `instance (Eq a) => Eq (Fpair s a)`
you block the type parameters (s and a) and leave no "free" parameters.

In fact, if instead you write only `instance (Eq a) => Eq Fpair` other than not having a way to
say that a should implement show, you get the error:
Expecting two more arguments to ‘Fpair’
Expected a type, but ‘Fpair’ has kind ‘* -> * -> *’

### Functor, Foldable, Applicative: 1 parameter
Functor, Foldable, Applicative instead need type constructors with a single free type parameter,
i.e. the type of the elements inside the "container": you can see that 
e.g. fmap :: (a -> b) -> f a -> f b wants a type with a
single free type param. describing the type of the element contained (like in lists). So we
"block" the separator type parameter s and leave as free one the contained
elements type parameter a, by writing `instance Functor (Fpair s)`.

If instead we wrote `instance Functor Fpair` we would get:
Expecting one more argument to ‘Fpair’
Expected kind ‘* -> *’, but ‘Fpair’ has kind ‘* -> * -> *’
if instead we wrote instance Functor (Fpair s a) we would get:
Expected kind ‘* -> *’, but ‘Fpair s a’ has kind ‘*’

## Foldable
```
foldr :: (a -> b -> b) -> b -> [a] -> b

instance Foldable [] where
foldr f z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

-- foldl is automatically deducted from foldr because:
foldl f a bs = foldr (\b g x -> g (f x b)) id bs a
```

## Functor
```
-- f is a container and infix version is <$>
fmap :: (a -> b) -> f a -> f b

> fmap (+1) [1, 2, 3]
> [2, 3, 4]
```

Functor laws (have to be enforced by programmer)
```
fmap id = id
fmap (f . g) = fmap f . fmap g -- where "." is function composition
```

## Applicative
```
class (Functor f) => Applicative f where
pure :: a -> f a -- put value in container (most basic available if union type)
(<*>) :: f (a -> b) -> f a -> f b -- AKA apply

-- implementation for Maybe
instance Applicative Maybe where
  pure = Just
  Nothing <*> _ = Nothing
  (Just f) <*> something = fmap f something
```

### Making a Foldable list instance of Applicative
```
concat :: Foldable t => t [a] -> [a]
concat l = foldr (++) [] l 	-- for general type C: define (++)-like op on C and
				-- substitute "[]" with empty-like version of C data cnstr
> concat [[1, 2], [3], [4, 5]] 
> [1, 2, 3, 4, 5]

concatMap f l = concat $ fmap f l

> concatMap (\x -> [x, x + 1]) [1, 2, 3]
> [1, 2] ++ [2, 3] ++ [3, 4] = [1, 2, 2, 3, 3, 4]

instance Applicative [] where
pure x = [x]
fs <*> xs = concatMap (\f -> fmap f xs) fs

> [(+1), (*2)] <*> [1, 2, 3]
> concatMap (\f -> fmap f [1, 2, 3]) [(+1), (*2)] = 
> = concatMap [f1, f2, f3] [(+1), (*2)] =
> = concat $ fmap [f1, f2, f3] [(+1), (*2)] =
> = concat [[1+1, 2+1, 3+1], [1*2, 2*2, 3*2]] =
> = [1+1, 2+1, 3+1] ++ [1*2, 2*2, 3*2] = [2, 3, 4, 2, 4, 6]
```

## Monad
```
class Applicative m => Monad m where
-- bind is same as pipe "|" operator in bash but with typing
(>>=) :: m a -> (a -> m b) -> m b

-- all following automatically deducted
-- same as bind but discard output of left operation, while still propagating fails (Nothing)
(>>) :: m a -> m b -> m b
m >> k = m >>= k \_ -> k

return :: a -> m a
return = pure

fail :: String -> m a
fail s = error s

-- implementation for Maybe, representing Det computations
instance Monad Maybe where
(Just x) >>= k = k x
Nothing >>= _ = Nothing
fail _ = Nothing -- to avoid stopping the computation and instead return an empty Maybe

> Just 4 >>= Just >> Nothing >> Just 6		-- the first bind result is given to the
> = Just 4 >> Nothing >> Just 6 = Nothing	-- Just, but nothing is propagated to end

-- implementation for [], representing ND computations
instance Monad [] where
xs >>= f = concatMap f xs
fail _ = []
```

### Making a Tree an instance of Monad
```
-- use same technique as list implementation
instance Monad Tree where
xs >>=f = tconcmap f xs
fail _ = Empty
```

## State Monad
```
instance Monad (State s) where
    return x = State $ \s -> (x,s)
    (State h) >>= f = State $ \s ->
        let (a, newState) = h s
            (State g) = f a
        in  g newState
```