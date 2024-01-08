{-
Consider a Slist data structure for lists that store their length. Define the Slist data structure, and make it an
instance of Foldable, Functor, Applicative and Monad.
-}
-- all good (followed usual rules)

data Slist a = Slist Integer [a] deriving Show

instance Foldable Slist where
  foldr f i (Slist _ xs) = foldr f i xs

instance Functor Slist where
  fmap f (Slist x xs) = Slist x (fmap f xs)

(Slist x xs) +++ (Slist y ys) = Slist (x + y) (xs ++ ys)

slConcat sl = foldr (+++) (Slist 0 []) sl

slConcatMap f sl = slConcat $ fmap f sl

instance Applicative Slist where
  pure x = Slist 1 [x]
--(<*>) :: Slist (a -> b) -> Slist a -> Slist b
  fs <*> xs = slConcatMap (\f -> fmap f xs) fs

instance Monad Slist where
  xs >>= f = slConcatMap f xs
  --fail _ = Slist 0 []

{- PROF's SOLUTION BELOW: doesn't follow usual rules

data Slist a = Slist Int [a] deriving (Show, Eq)

makeSlist v = Slist (length v) v

instance Foldable Slist where
  foldr f i (Slist n xs) = foldr f i xs

instance Functor Slist where
  fmap f (Slist n xs) = Slist n (fmap f xs)

instance Applicative Slist where
  pure v = Slist 1 (pure v)
  (Slist x fs) <*> (Slist y xs) = Slist (x*y) (fs <*> xs)

instance Monad Slist where
  --fail _ = Slist 0 []
  (Slist n xs) >>= f = makeSlist (xs >>= (\x -> let Slist n xs = f x
                                                in xs))

-}