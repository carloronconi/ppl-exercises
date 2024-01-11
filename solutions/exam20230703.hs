data Lv a = El a | Ls [a] deriving Show

data D2L a = D2L [(Lv a)] deriving Show

lv2list (El x) = [x]
lv2list (Ls xs) = xs

flatten (D2L xs) = foldr (++) [] $ fmap lv2list xs

instance Functor Lv where
  fmap f (El x) = El (f x)
  fmap f (Ls xs) = Ls (fmap f xs)

instance Functor D2L where
  fmap f (D2L xs) = D2L (fmap (\x -> fmap f x) xs)

instance Foldable D2L where
  foldr f i d = foldr f i $ flatten d

(+++) (D2L xs) (D2L ys) = D2L (xs ++ ys)

d2lconcat d = foldr (+++) (D2L [])  d

d2lconcatMap f d = d2lconcat $ fmap f d

instance Applicative D2L where
  pure x = D2L [(El x)]
  fs <*> xs = d2lconcatMap (\f -> fmap f xs) fs

-- flatten (D2L [(El 1), (Ls [2, 3, 4]), (El 5), (El 6)])
-- (D2L [(El (+1)), (Ls [(*2), (*3)]), (El (-4))]) <*> (D2L [(El 1), (Ls [2, 3, 4]), (El 5), (El 6)])

(D2L [(El (\x -> x + 1)), (Ls [(\x -> x * 2), (\x -> x * 3)]), (El (\x -> x - 4))]) <*> (D2L [(El 1), (Ls [2, 3, 4]), (El 5), (El 6)])