module Mon where

result = Just 1 >>= Just >> Just 3 >> Nothing >> Just 6

comp = [(x, y) | x <- [1,2,3], y <- [1,2,3]]

main = do {
putStr "Please, tell me something> ";
thing <- getLine;
putStrLn $ "You told me \"" ++ thing ++ "\".";
}

main2 = putStr "Please daddy tell me something> " >> getLine >>= \l -> putStrLn $ "You told me \"" ++ l ++ "\"."