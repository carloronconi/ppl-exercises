module Main3 where

  -- this syntax is required to import both data constructors and the method
  import Tree3 ( Tree3 (Leaf), Tree3 (Branch), fringe)

  fr = fringe t where t = Branch (Leaf 1) (Branch (Leaf 2) (Leaf 3) (Leaf 4)) (Leaf 5)
