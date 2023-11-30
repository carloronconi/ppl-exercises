module Ex where

data Tvtl a = Tv a a | Tl [a] [a] deriving (Show, Eq)

instance Foldable Tvtl where
--foldr :: (a -> b -> b) -> b -> Tvtl a -> b
  foldr f z (Tv x y) = f x (f y z)
  foldr f z (Tl lx ly) = foldr f (foldr f z ly) lx
  -- only mistake swapped order lx and (foldr f z ly) not too severe as compiler recognized type mismatch: lx :: [a] while (foldr f z ly) :: a