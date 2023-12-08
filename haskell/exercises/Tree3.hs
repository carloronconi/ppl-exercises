module Tree3 ( Tree3(Leaf, Branch), fringe ) where

  data Tree3 a = Leaf a | Branch (Tree3 a) (Tree3 a) (Tree3 a)

  fringe :: Tree3 a -> [a]
  fringe (Leaf l) = [l]
  fringe (Branch x y z) = (fringe x) ++ (fringe y) ++ (fringe z)
