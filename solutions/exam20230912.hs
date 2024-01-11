data BT a = Nil | Leaf a | Branch (BT a) (BT a) deriving Show

-- 1)

btrees x = build_bt_lst x 0

build_bt_lst x n = [(build_bt x n)] ++ (build_bt_lst x (n + 1))

build_bt x 0 = Leaf x
build_bt x n = Branch (build_bt x (n - 1)) (build_bt x (n - 1))

-- 2)

magic_bt_lst = build_mbt_lst 1 0

build_mbt_lst x n = [(build_bt x n)] ++ (build_mbt_lst (x + 1) (n + 1))

-- 3)

count_lst = build_count_lst 0 0

build_count_lst x acc = let curr = (2 ^ x) + acc
                        in [curr] ++ (build_count_lst (x + 1) curr)