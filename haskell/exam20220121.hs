-- Consider a Tvtl (two-values/two-lists) data structure, which can store either two values of a given type, or
-- two lists of the same type.
-- Define the Tvtl data structure, and make it an instance of Functor, Foldable, and Applicative.

module Ex where

data Tvtl a = Tv a a | Tl [a] [a] deriving (Show, Eq)

instance Foldable Tvtl where
--foldr :: (a -> b -> b) -> b -> Tvtl a -> b
foldr f z (Tv x y) = f x (f y z)
foldr f z (Tl lx ly) = foldr f (foldr f z ly) lx
  -- only mistake swapped order lx and (foldr f z ly) not too severe as compiler recognized type mismatch: lx :: [a] while (foldr f z ly) :: a

instance Functor Tvtl where
fmap f (Tv x y) = Tv (f x) (f y)
fmap f (Tl lx ly) = Tl (fmap f lx) (fmap f ly)
-- all good

-- instance Applicative Tvtl where
-- pure x y = Tv x y
-- example usage: Tv (+1) (*2) <*> (Tv 1 2) = (Tv (Tv (+1 1) (+1 2)) (Tv (+2 1) (+2 2))
-- (Tv fx fy) <*> (Tv x y) = (Tv ) -- no actually read theory slides to use same strategy as lists (with concatMap) ALL WRONG

-- follow concatMap for lists pattern: first define something like concat (here with 3 +'s) for all cases
(Tv x y) +++ (Tv z w) = Tl [x,y] [y,w]
(Tv x y) +++ (Tl l r) = Tl (x:l) (y:r)
(Tl l r) +++ (Tv x y) = Tl (l++[x]) (r++[y])
(Tl l r) +++ (Tl x y) = Tl (l++x) (r++y)

-- then use exactly the same defs as concatMap for lists, choosing (Tl [][]) as the "empty" (in lists it is [])
tvtlconcat t = foldr (+++) (Tl [][]) t
tvtlcmap f t = tvtlconcat $ fmap f t

-- finally follow exactly same defs as concatMap for lists, choosing pure as (Tl [x] []) as impossible to give single value to Tv
instance Applicative Tvtl where
pure x = Tl [x] []
x <*> y = tvtlcmap (\f -> fmap f y) x

