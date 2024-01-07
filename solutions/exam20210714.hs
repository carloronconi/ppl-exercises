{-
1) Define a "generalized" zip function which takes a finite list of possibly infinite lists, and returns a possibly
infinite list containing a list of all the first elements, followed by a list of all the second elements,and so on.
E.g. gzip [[1,2,3],[4,5,6],[7,8,9,10]] ==> [[1,4,7],[2,5,8],[3,6,9]]

2) Given an input like in 1), define a function which returns the possibly infinite list of the sum of the two greatest
elements in the same positions of the lists.E.g. sum_two_greatest [[1,8,3],[4,5,6],[7,8,9],[10,2,3]] ==> [17,16,15]

gzip [[1,2,3],[4,5,6],[7,8,9,10]] ==> zip [1,2,3] $ zip [4,5,6],[7,8,9,10] = zip [1,2,3] [(4,7),(5,8),(6,9)]

gzip [] -> []
gzip [l] -> l
gzip [(l1:l2:ls)] -> gzip []

gzip l = foldr zip [] l

tupleToList (x) = [x]
tupleToList (x,y) = [x,y]
tupleToList (x,y,r) = [x,y] ++ tupleToList r

szip [] _ = [[]]
szip _ [] = [[]]
szip (x:xs) (y:ys) = [[x,y], szip xs ys]
-}

-- 1) prof's solution
gzip xs = if null (filter null xs) then (map head xs) : gzip (map tail xs) else []
{-
the meaning is:
gzip xs = if [] == (filter [] xs) then (map head xs) : gzip (map tail xs) else []
we filter for empty lists, if there are none we get an empty list, if there are some we get a list of N empty lists
I'm not sure why but written like this it doesn't compile. The null version works because:
*Main> null []
True
*Main> null [[]]
False
-}

-- 2)
-- added function for improved version also accounting for negative values
add_two_greatest_lst [] = 0
add_two_greatest_lst [x] = x
add_two_greatest_lst [x,y] = x + y
add_two_greatest_lst (x:y:rst) | x >= y = add_two_greatest x y rst
                               | x < y = add_two_greatest y x rst

-- define function that given list returns sum of its two greatest elements
add_two_greatest first second [] = first + second
add_two_greatest first second [x] | x <= second = first + second
                                  | x > second = first + x
add_two_greatest first second (x:xs) | x <= second = add_two_greatest first second xs
                                     | x > second && x <= first = add_two_greatest first x xs
                                     | x > second && x > first = add_two_greatest x first xs

-- use it together with gzip: map add_two_greatest -inf -inf $ gzip l
sum_two_greatest :: (Num a, Ord a) => [[a]] -> [a]
--sum_two_greatest l = map (add_two_greatest (-1000) (-1000)) $ gzip l -- it works! but only if all values are greater than -1000

-- improved version which also works for negative values
sum_two_greatest l = map add_two_greatest_lst $ gzip l

-- prof's solution for second part: same logic as my improved version but more elegant thanks to foldr
store_two_greatest v (x,y) | v > x = (v,y)
store_two_greatest v (x,y) | x >= v && v > y = (x,v)
store_two_greatest v (x,y) = (x,y)

two_greatest (x:y:xs) = foldr store_two_greatest (if x > y then (x,y) else (y,x)) xs

sum_two_greatest xs = [let (x,y) = two_greatest v
                       in x+y | v <- gzip xs]