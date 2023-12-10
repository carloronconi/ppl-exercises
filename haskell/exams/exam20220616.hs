-- Consider the "fancy pair" data type (called Fpair), which encodes a pair of the same type a, and may
-- optionally have another component of some "showable" type b, e.g. the character '$'.
-- Define Fpair, parametric with respect to both a and b.
-- 1) Make Fpair an instance of Show, where the implementation of show of a fancy pair e.g. encoding
--    (x, y, '$') must return the string "[x$y]", where x is the string representation of x and y of y. If the third
--    component is not available, the standard representation is "[x, y]".
-- 2) Make Fpair an instance of Eq — of course the component of type b does not influence the actual
--    value, being only part of the representation, so pairs with different representations could be equal.
-- 3) Make Fpair an instance of Functor, Applicative and Foldable.

-- MY QUESTIONS
-- DO DATA CONSTRUCTORS NEED TO HAVE DIFFERENT NAMES EVEN IF DIFFERENT NUMBER OF ARGS? -> yes
-- DOES EQ WORK MY WAY OR NEED TO USE SIMPLIFY FROM SOL? -> not using simplify but separate the cases
-- WOULD APPLICATIVE HAVE BEEN FINE LIKE I DID? I WAS THOUGHT ABOUT HOW SOL DOES IT BUT THOUGHT MY WAY MORE SIMILAR TO LISTS COMPUTING ALL PERMUTATIONS
    -- -> no, because when compiling you get
    --    Occurs check: cannot construct the infinite type: b ~ Fpair s b
           --        Expected type: Fpair s b
           --        Actual type: Fpair s (Fpair s b)
    -- which means in general with apply you need to output a "flat" object due to the signature (<*>) :: f (a -> b) -> f a -> f b
-- DO FOLDABLE AND EQ MATCH ALL CASES? -> add separate cases

-- how restrict b to be instance Show? Just need to do that in methods that require it (i.e. Show)
data Fpair s a = Pair a a | Fpair a a s

instance (Show a, Show s) => Show (Fpair s a) where
  show (Pair x y) = "[" ++ (show x) ++ ", " ++ (show y) ++ "]"
  show (Fpair x y sep) = "[" ++ (show x) ++ (show sep) ++ (show y) ++ "]"

instance (Eq a) => Eq (Fpair s a) where
  (Fpair x1 y1 _) == (Fpair x2 y2 _) = x1 == x2 && y1 == y2
  (Pair x1 y1) == (Pair x2 y2) = x1 == x2 && y1 == y2

instance Functor (Fpair s) where
  fmap f (Fpair x y sep) = (Fpair (f x) (f y) sep)
  fmap f (Pair x y) = (Pair (f x) (f y))

instance Foldable (Fpair s) where
  foldr f z (Fpair x y _) = f x $ f y z
  foldr f z (Pair x y) = f x $ f y z

-- (+++) (Fpair x1 y1 s1) (Fpair x2 y2 s2) = (Fpair (Fpair x1 y1 s1) (Fpair x2 y2 s2)) -- do I need to define other cases or blank seps matched already?
-- pconcat p = foldr (+++) [] p -- there's no notion of empty pair so can't do it this way! Either create (++) for Fpair and use empty list or what?? Actually def. Applicative from scratch!

--instance Applicative (Fpair s) where
--  pure x = Pair x x -- didn't know how to do it!
--  (Fpair fx fy fs) <*> (Fpair x y s) = Fpair (Fpair (fx x) (fx y) s) (Fpair (fy x) (fy y) s) fs
--  (Pair fx fy) <*> (Fpair x y s) = Pair (Fpair (fx x) (fx y) s) (Fpair (fy x) (fy y) s)
--  (Fpair fx fy fs) <*> (Pair x y) = Fpair (Pair (fx x) (fx y)) (Pair (fy x) (fy y)) fs
--  (Pair fx fy) <*> (Pair x y) = Pair (Pair (fx x) (fx y)) (Pair (fy x) (fy y))

instance Applicative (Fpair s) where
  pure x = Pair x x
  (Fpair fx fy _) <*> (Fpair x y sep) = Fpair (fx x) (fy y) sep
  (Pair fx fy) <*> (Fpair x y sep) = Fpair (fx x) (fy y) sep
  (Fpair fx fy sep) <*> (Pair x y) = Fpair (fx x) (fy y) sep
  (Pair fx fy) <*> (Pair x y) = Pair (fx x ) (fy y)