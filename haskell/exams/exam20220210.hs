--Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a
  --variable number of children.
  --1. Define the Gtree data structure.
  --2. Define gtree2list, i.e. a function which translates a Gtree to a list.
  --3. Make Gtree an instance of Functor, Foldable, and Applicative.

module Exam where

-- 1.
data Gtree a = Empty | Leaf a | Branch (a) ([Gtree a]) deriving Show

-- 2.
gtree2list :: Gtree a -> [a]
gtree2list (Empty) = []
gtree2list (Leaf a) = [a]
gtree2list (Branch val lst) = [val] ++ (lst >>= gtree2list) -- bind for lists is concatMap

-- 3.
instance Foldable Gtree where



-- testing it:
tree = Branch 1 ([Branch (2) ([Empty, Leaf 3, Leaf 4]), Leaf 5, Branch 6 ([Leaf 7, Leaf 8, Empty])])