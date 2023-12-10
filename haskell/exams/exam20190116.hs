--We want to define a data structure, called Listree, to define structures working both as lists and as binary
  --trees, like in the next figure. (see PDF)

  --1) Define a datatype for Listree.
  --2) Write the example of the figure with the defined data structure.
  --3) Make Listree an instance of Functor.
  --4) Make Listree an instance of Foldable.
  --5) Make Listree an instance of Applicative.


-- 1) possibilities: two nodes, one node and one element, one element
data Listree a = Split (Listree a) (Listree a) | Branch a (Listree a) | Leaf a | Empty deriving Show
-- SOLUTIONS NOTE: I did it this way because I added Empty while solving q5, after doing that I could have eliminated
-- the (Leaf a) case as you can just build a (Branch a Empty)

-- 2)
example1 = Split (Leaf 1) (Branch 2 (Split (Split (Leaf 3) (Leaf 4)) (Branch 5 (Branch 6 (Leaf 7)))))

-- example2 :: Listree Integer -- added by me
example2 = Split (Split (Branch 8 (Leaf 9)) (Split (Leaf 10) (Empty))) (Leaf 11)

-- test
toList :: Listree a -> [a]
toList (Empty) = []
toList (Leaf x) = [x]
toList (Branch x xs) = x:(toList xs)
toList (Split xs ys) = (toList xs) ++ (toList ys)

-- 3)
instance Functor Listree where
  fmap f (Empty) = Empty
  fmap f (Leaf x) = Leaf (f x)
  fmap f (Branch x xs) = Branch (f x) (fmap f xs)
  fmap f (Split xs ys) = Split (fmap f xs) (fmap f ys)

-- 4)
instance Foldable Listree where
  foldr f z (Empty) = z
  foldr f z (Leaf x) = f x z
  foldr f z (Branch x xs) = f x (foldr f z xs)
  foldr f z (Split xs ys) = foldr f (foldr f z ys) xs -- SOLUTIONS NOTE: I inverted xs and ys but I think it's right??
                                                      -- foldr f z (x:xs) = f x (foldr f z xs)

-- 4) alternative
-- instance Foldable Listree where
--   foldr f z t = foldr f z $ toList t

-- 5) skipping concat would make leaving structure complex: maintain original of Listree of operands and of functions, so use concat approach to achieve this
(+++) :: Listree a -> Listree a -> Listree a
(+++) (Empty) t = t
(+++) t (Empty) = t -- required otherwise doing `example1 +++ Empty` yields extra "Empty" at the end: Split (Leaf 1) (Branch 2 (Split (Split (Leaf 3) (Leaf 4)) (Branch 5 (Branch 6 (Branch 7 Empty)))))
(+++) (Leaf x) t = (Branch x t)
(+++) (Branch x xs) t = Branch x $ xs +++ t
(+++) (Split x y) t = Split x $ y +++ t

ltConcat lt = foldr (+++) Empty lt
ltConcatMap f lt = ltConcat $ fmap f lt

instance Applicative Listree where
  pure x = Leaf x
  x <*> y = ltConcatMap (\f -> fmap f y) x