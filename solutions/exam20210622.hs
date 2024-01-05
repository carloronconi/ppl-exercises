{-
Define a data-type called BTT which implements trees that can be binary or ternary, and where every node contains a
value, but the empty tree (Nil). Note: there must not be unary nodes, like leaves.

1) Make BTT an instance of Functor and Foldable.

2) Define a concatenation for BTT, with the following constraints:•If one of the operands is a binary
node, such node must become ternary, and the other operand will become the added subtree (e.g. if the binary node is
the left operand, the rightmost node of the new ternary node will be the right operand).•If both the operands are
ternary nodes, the right operand must be appened on the right of the left operand, by recursively calling concatenation.

3) Make BTT an instance of Applicative.
-}

-- 1
data BTT a = Ter a (BTT a) (BTT a) (BTT a) | Bin a (BTT a) (BTT a) | Nil

instance Functor BTT where
  fmap f Nil = Nil
  fmap f (Bin v tx ty) = Bin (f v) (fmap f tx) (fmap f ty)
  fmap f (Ter v tx ty tz) = Ter (f v) (fmap f tx) (fmap f ty) (fmap f tz)

instance Foldable BTT where
  foldr f z Nil = z
  foldr f z (Bin v tx ty) = f v (foldr f (foldr f z ty) tx)
  foldr f z (Ter v tx ty tz) = f v (foldr f (foldr f (foldr f z tz) ty) tx)

-- 2
(+++) :: BTT a -> BTT a -> BTT a
Nil +++ x = x
x +++ Nil = x
(Bin v tx ty) +++ t = (Ter v tx ty t)
t +++ (Bin v tx ty) = (Ter v t tx ty)
(Ter v tx ty tz) +++ t = (Ter v tx ty (tz +++ t))

-- 3
tconcat t = foldr (+++) Nil t

tconcatmap f t = tconcat $ fmap f t

instance Applicative BTT where
  pure x = (Bin x Nil Nil)
  fs <*> xs = tconcatmap (\f -> fmap f xs) fs