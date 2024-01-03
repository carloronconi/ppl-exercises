{-
Consider a data type PriceList that represents a list of items, where each item is associated with a price, of type
Float: data PriceList a = PriceList [(a, Float)]

1) Make PriceList an instance of Functor and Foldable.
2) Make PriceList an instance of Applicative, with the constraint that each application of a function in the left hand
side of a <*> must increment a right hand side value’s price by the price associated with the function.

E.g.
PriceList [(("nice "++), 0.5), (("good "++), 0.4)]  <*> PriceList [("pen", 4.5), ("pencil", 2.8), ("rubber", 0.8)]

is:
PriceList [("nice pen",5.0),("nice pencil",3.3),("nice rubber",1.3),("good pen",4.9),("good pencil",3.2),("good rubber",1.2)]
-}

data PriceList a = PriceList [(a, Float)] deriving Show

-- 1.

(+++) (PriceList []) x = x
(+++) x (PriceList []) = x
(+++) (PriceList x) (PriceList y) = PriceList $ x ++ y

instance Functor PriceList where
  fmap f (PriceList []) = PriceList []
  fmap f (PriceList ((x1,x2):xs)) = (PriceList [((f x1), x2)]) +++ (fmap f (PriceList xs))

plfoldr :: (a -> b -> b) -> b -> PriceList a -> b
plfoldr f z (PriceList []) = z
plfoldr f z (PriceList((x, p):xs)) = f x (plfoldr f z (PriceList xs)) -- error here instead of (PriceList xs) I had just put xs so the compiler was complaining

instance Foldable PriceList where
  foldr f z pl = plfoldr f z pl

-- 2.

pConcat pl = foldr (+++) (PriceList []) pl

pConcatMap f pl = pConcat $ fmap f pl

pmap f v (PriceList prices) = PriceList $ fmap (\x -> let (a, p) = x
                                                      in (f a, p+v)) prices

instance Applicative PriceList where
  pure x = PriceList [(x, 0.0)]

  -- fs <*> xs = pConcatMap (\f -> fmap f xs) fs
  -- (PriceList []) <*> _ = PriceList []
  -- (PriceList ((f,fp):fs)) <*> (PriceList ((x,xp):xs))
  -- fs <*> xs = pConcatMap (\f -> fmap f (changep fs xs)) fs where
  --  changep -- this can't work because I can change prices on single list but not the combination

-- looked at solution and realized that you need a special fmap just for that reason, which also takes a price into account.
-- that special function is called pmap, added above. Now we can define apply:
  (PriceList fs) <*> xs = pConcatMap (\ff -> let (f,v) = ff in pmap f v xs) fs -- didn't completely understand the lambda he used here but it works

{- tests
fmap (\x -> x ++ " appendix") (PriceList [("pen", 4.5), ("pencil", 2.8), ("rubber", 0.8)])
> PriceList [("pen appendix",4.5),("pencil appendix",2.8),("rubber appendix",0.8)]

foldr (\x y -> x ++ y) "" (PriceList [("pen", 4.5), ("pencil", 2.8), ("rubber", 0.8)])
> "penpencilrubber"

PriceList [(("nice "++), 0.5), (("good "++), 0.4)]  <*> PriceList [("pen", 4.5), ("pencil", 2.8), ("rubber", 0.8)]
> PriceList [("nice pen",5.0),("nice pencil",3.3),("nice rubber",1.3),("good pen",4.9),("good pencil",3.2),("good rubber",1.2)]
-}