{-
1) Define a Tritree data structure, i.e. a tree where each node has at most 3 children, and every node contains
a value.
2) Make Tritree an instance of Foldable and Functor.
3) Define a Tritree concatenation t1 +++ t2, where t2 is appended at the bottom-rightmost position of t1.
4) Make Tritree an instance of Applicative.
-}

-- 1)
data Subtrees a = Nil
                | One (Tritree a)
                | Two (Tritree a) (Tritree a)
                | Three (Tritree a) (Tritree a) (Tritree a)
data Tritree a = Tritree (a) (Subtrees a)

-- 2)
instance Foldable Subtrees where
  foldr f z Nil = z
  foldr f z (One a) = foldr f z a
  foldr f z (Two a b) = tfoldr f (tfoldr f z b) a
  foldr f z (Three a b c) = tfoldr f (tfoldr f (tfoldr f z c) b) a

instance Foldable Tritree where
  foldr f z (Tritree x s) = f x (foldr f z s)

instance Functor Subtrees where
  fmap f Nil = Nil
  fmap f (One x) = One (fmap f x)
  fmap f (Two x y) = Two (fmap f x) (fmap f y)
  fmap f (Three x y z) = Three (fmap f x) (fmap f y) (fmap f z)

instance Functor Tritree where
  fmap f (Tritree v s) = (Tritree (f v) (fmap f s))

-- 3)
(+++) :: Tritree a -> Tritree a -> Tritree a
(+++) (Tritree v Nil) t = (Tritree v (One t))
(+++) (Tritree v (One x)) t = (Tritree v (One (x +++ t)))
(+++) (Tritree v (Two x y)) t = (Tritree v (Two x (y ++ t)))
(+++) (Tritree v (Three x y z)) t = (Tritree v (Three x y (z +++ t)))

-- 4)
-- concatT = foldr (+++) (Tritree ...) AGAIN NO EMPTY STRUCTURE: REMEMBER IT'S NEEDED TO DEF APPLICATIVE!
-- I thought "and every node contains a value" meant that no empty valued nodes were allowed. By allowing empty tritrees
-- everything is much easier. Let's re-do it...

-- checked everything and everything is the same (with the different Subtrees def.) apart from +++, where I don't
-- understand the logic