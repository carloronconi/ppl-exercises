import Control.Monad.State
--module Mon where

result = Just 1 >>= Just >> Just 3 >> Nothing >> Just 6

comp = [(x, y) | x <- [1,2,3], y <- [1,2,3]]

main = do {
putStr "Please, tell me something> ";
thing <- getLine;
putStrLn $ "You told me \"" ++ thing ++ "\".";
}

main2 = putStr "Please daddy tell me something> " >> getLine >>= \l -> putStrLn $ "You told me \"" ++ l ++ "\"."

exmon :: (Monad m, Num r) => m r -> m r -> m r
exmon m1 m2 = do
  x <- m1
  y <- m2
  return $ x-y

lst = exmon [10, 11] [1, 7]

strange = exmon (do
  putStr "?> "
  x <- getLine
  return (read x :: Int))
  (return 10)

runStateM (StateT f) st = f st

ex = runStateM (do
  x <- return 5
  return (x+1))
  333