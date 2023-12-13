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
data BFlist a = Flist [a] | Blist [a]

-- 2)
instance (Eq a) => (BFlist a) where
  (==) (Flist x) (Flist y) = x == y -- x and y are lists: they implement Eq because a does
  (==) (Flist _) (Blist _) = False
  (==) (Blist _) (Flist _) = False
  (==) (Blist x) (Blist y) = x == y

instance (Show a) => (BFlist a) where
  show (Flist x) = "+" ++ (show x)
  show (Blist x) = "-" ++ (show x)

-- 3)
{- my first wrong attempt (I got stuck)
longest :: [a] -> [a] -> Integer
longest x y = if ((length x) > (length y))
  then 1
  else if ((length x) < (length y))
  then 2
  else 0

fbconstr :: [a] -> [a] -> BFlist a -- first list from F and second from B
fbconstr f b | (length f) - (length b) > 0 = let diff =

(<++>) :: BFlist a -> BFlist a -> BFlist a
(<++>) (Flist x) (Flist y) = Flist $ x ++ y
(<++>) (Flist x) (Blist y) = case ((length x) - (length y)) of
  (1) -> Flist
  (2) ->
  (0) ->
(<++>)
(<++>) (Blist x) (Blist y) = Blist $ x ++ y
-}

-- re-doing similar to sol in new file