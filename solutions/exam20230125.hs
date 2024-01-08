{-
We want to define a data structure for the tape of a Turing machine: Tape is a parametric data structure with respect
to the tape content, and must be made of three components:

1.the portion of the tape that is on the left of the head;
2.the symbol on which the head is positioned;
3.the portion of the tape that is on the right of the head.

Also, consider that the machine has a concept of "blank" symbols, so you need to add another component in the data
definition to store the symbol used to represent the blank in the parameter type.

1.Define Tape.
2.Make Tape an instance of Show and Eq, considering that two tapes contain the same values if their stored values
are the same and in the same order, regardless of the position of their heads.
3.Define the two functions left and right, to move the position of the head on the left and on the right.
4.Make Tape an instance of Functor and Applicative
-}

-- all good: only difference in q4 prof's solution doesn't comply with 1st applicative rule
-- mine seems to make more sense

-- 1.
data Tape a = Tape a [a] a [a]

buildTape blank x:xs = Tape blank [] x xs

-- 2.
instance (Show a) => Show (Tape a) where
  show (Tape b ls x rs) = (show ls) ++ " {" ++ (show x) ++ "} " ++ (show rs) ++ " blank: " ++ (show b)

toList (Tape _ ls x rs) = ls ++ [x] ++ rs

instance (Eq a) => Eq (Tape a) where
  lt@(Tape lb _ _ _) == rt@(Tape rb _ _ _) = ((toList lt) == (toList rt)) && lb == rb

-- 3.
right (Tape b ls x r:rs) = Tape b (ls ++ [x]) r rs

left (Tape b ls x rs) = Tape b (init ls) (last ls) x:rs

-- 4.
instance Functor Tape where
  fmap f (Tape b ls x rs) = Tape (f b) (fmap f ls) (f x) (fmap f rs) -- I forgot to apply f to blank

instance Applicative Tape where
  pure x = Tape x [] x [] -- the character is also the blank
  (Tape fb fls fx frs) <*> (Tape b ls x rs) = Tape (fb b) (fls <*> ls) (fx x) (frs <*> rs)

{- PROF's SOLUTION
instance Applicative Tape where
  pure x = Tape [] x [] x
  -- zipwise apply
  (Tape fx fc fy fb) <*> (Tape x c y b) = Tape (zipApp fx x) (fc c) (zipApp fy y) (fb b)
      where zipApp x y = [f x | (f,x) <- zip x y]
-}