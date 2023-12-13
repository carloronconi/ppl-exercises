{-
We want to define a data structure, called BFlist (Back/Forward list), to define lists that can either be
“forward” (like usual list, from left to right), or “backward”, i.e. going from right to left.
We want to textually represent such lists with a plus or a minus before, to state their direction: e.g. +[1,2,3] is
a forward list, -[1,2,3] is a backward list.
Concatenation (let us call it <++>) for BFlist has this behavior: if both lists have the same direction, the
returned list is the usual concatenation. Otherwise, forward and backward elements of the two lists delete
each other, without considering their stored values.
For instance: +[a,b,c] <++> -[d,e] is +[c], and -[a,b,c] <++> +[d,e] is -[c].
1) Define a datatype for BFlist.
2) Make BFList an instance of Eq and Show, having the representation presented above.
3) Define <++>, i.e. concatenation for BFList.
4) Make BFList an instance of Functor.
5) Make BFList an instance of Foldable.
6) Make BFList an instance of Applicative.
-}

-- 1)
data Sign = Forward | Backward deriving (Eq)
data BFlist a = BFlist Sign [a]

-- 2)
instance (Eq a) => (BFlist a) where
  (==) (BFlist s1 l1) (BFlist s2 l2) = (s1 == s2) && (l1 == l2)

instance Show Sign where
  show Forward = "+"
  show Backward = "-"

instance (Show a) => (BFlist a) where
  show (BFlist s l) = (show s) ++ (show x)

-- 3)
(<++>) :: BFlist a -> BFlist a -> BFlist a
(<++>) (BFlist _ []) bf = bf
(<++>) bf (BFlist _ []) = bf
(<++>) (BFlist sx lx) (BFlist sy ly) | sx == lx = (BFlist sx (lx ++ ly))
(<++>) (BFlist sx l:lx) (BFlist sy l:ly) = (BFlist sx lx) <++> (BFlist sy ly)

-- 4)
instance Functor BFlist where
  fmap f (BFlist s l) = (BFlist s (fmap f l))

-- 5)
instance Foldable BFlist where
  foldr f z (BFlist s l) = foldr f z l

-- 6) we have already defined a concatenation as requested, so follow that to decide apply behaviour
concatBfl bfl = foldr (<++>) (BFlist Forward []) bfl -- solution uses same sign as bfl for empty one: makes more sense
concatMapBfl f bfl = concatBfl $ fmap f bfl

instance Applicative BFlist where
  pure x = BFlist Forward [x]
  fs <*> xs = concatMapBfl (\f -> fmap f xs) fs
