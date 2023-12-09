--Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a
  --variable number of children.
  --1. Define the Gtree data structure.
  --2. Define gtree2list, i.e. a function which translates a Gtree to a list.
  --3. Make Gtree an instance of Functor, Foldable, and Applicative.
import Prelude

-- 1.
data Gtree a = Empty | Branch a [Gtree a] deriving Show

-- 2.
gtree2list :: Gtree a -> [a]
gtree2list (Empty) = []
gtree2list (Branch val lst) = [val] ++ (concatMap gtree2list lst)

-- 3.
instance Foldable Gtree where
foldr f z (Empty) = Empty
foldr f z gtree = Prelude.foldr f z $ gtree2list gtree

instance Functor Gtree where
fmap f (Empty) = Empty
fmap f (Branch val lst) = Branch (f val) (Prelude.fmap (Prelude.fmap f) lst) -- not quite understand why nested fmap required

(+++) :: Gtree a -> Gtree a -> Gtree a
Empty +++ Empty = Empty
Empty +++ t = t
t +++ Empty = t
(Gtree x xs) +++ (Gtree y ys) = Gtree y ((Gtree x []:xs) ++ ys) -- why would +++ work like this?

concat t = foldr (+++) Empty t

concatMap f t = concat $ fmap f t

instance Applicative Gtree where
pure x = Branch x []
tl <*> tr = concatMap (\f -> fmap f tr) tl


-- testing it:
tree = Branch 1 ([Branch (2) ([Empty, Leaf 3, Leaf 4]), Leaf 5, Branch 6 ([Leaf 7, Leaf 8, Empty])])