module Associativity where

  binOpA x y = x ++ "A" ++ y
  binOpB x y = x ++ "B" ++ y

  result = binOpA "xxx" (binOpB "yyy" "zzz")
  result2 = binOpA "xxx" $ binOpB "yyy" "zzz"

