--Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a
  --variable number of children.
  --1. Define the Gtree data structure.
  --2. Define gtree2list, i.e. a function which translates a Gtree to a list.
  --3. Make Gtree an instance of Functor, Foldable, and Applicative.
import Prelude

-- 1.
data Gtree a = Empty | Leaf a | Branch (a) ([Gtree a]) deriving Show -- could have been made simpler by avoiding Leaf
-- as you can just create a branch with an empty list

-- 2.
gtree2list :: Gtree a -> [a]
gtree2list (Empty) = []
gtree2list (Leaf a) = [a]
gtree2list (Branch val lst) = [val] ++ (lst >>= gtree2list) -- bind for lists is concatMap, sol uses concatMap so you can use that!!

-- 3.
instance Foldable Gtree where
foldr f z (Empty) = Empty
foldr f z (Leaf a) = f z a
-- foldr f z (Branch val lst) = f val $ foldr f z lst -- in this last foldr the lst is :: [Gtree a] so sol uses gtree2list
foldr f z gtree = Prelude.foldr f z $ gtree2list gtree

instance Functor Gtree where
fmap f (Empty) = Empty
fmap f (Leaf a) = Leaf $ f a
-- fmap f (Branch val lst) = Branch (f val) (fmap f lst) -- should be (fmap (fmap f) lst), not sure why but with my solution type clash between Gtree b and b and viceversa
fmap f (Branch val lst) = Branch (f val) (Prelude.fmap (Prelude.fmap f) lst)

(+++) :: Gtree a -> Gtree a -> Gtree a
Empty +++ Empty = Empty
Empty +++ t = t
t +++ Empty = t
-- TODO: here becomes complex to consider case with leaf: re-do exercise with correct data constructor

instance Applicative Gtree where


-- testing it:
tree = Branch 1 ([Branch (2) ([Empty, Leaf 3, Leaf 4]), Leaf 5, Branch 6 ([Leaf 7, Leaf 8, Empty])])