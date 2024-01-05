{-
We want to implement a queue, i.e. a FIFO container with the two operations
enqueue and dequeue with the obvious meaning. A functional way of doing this is
based on the idea of using two lists, say L1 and L2, where the first one is used
for dequeuing (popping) and the second one is for enqueing (pushing). When
dequeing, if the first list is empty, we take the second one and put it in the
first, reversing it. This last operation appears to be O(n), but suppose we
have n enqueues followed by n dequeues; the first dequeue takes time
proportional to n (revlst), but all the other dequeues take constant time.
This makes the operation O(1) amortised that is why it is acceptable in many
applications.

(i)
1) Define Queue and make it an instance of Eq
2) Define enqueue and dequeue, stating their types

(ii)
Make Queue an instance of Functor and Foldable

(iii)
Make Queue an instance of Applicative
-}

-- (i)
data Queue a = Queue [a] [a] deriving Show

-- it is already implemented in prelude as `reverse lst` (exactly same signature!)
revlst :: [a] -> [a]
revlst l = revlst2 l []

revlst2 :: [a] -> [a] -> [a]
revlst2 [] r = r
revlst2 (x:xs) r = revlst2 xs ([x] ++ r)

instance (Eq a) => Eq (Queue a) where
  (Queue [] lx) == (Queue [] ly) = lx == ly
  (Queue lx []) == (Queue ly []) = lx == ly
  (Queue [] lx) == (Queue ly []) = lx == (revlst ly)
  (Queue lx []) == (Queue [] ly) = lx == (revlst ly)
  _ == _ = False

enqueue :: Queue a -> a -> Queue a
enqueue (Queue [] l) e = Queue [] ([e] ++ l) -- same as doing (e:l)
enqueue (Queue l []) e = Queue [] ([e] ++ (revlst l)) -- other cases are wrong states

dequeue :: Queue a -> (Queue a, a) -- could change to Maybe a for when dequeueing empty queue
dequeue (Queue (x:xs) []) = ((Queue xs []), x)
dequeue (Queue [] l) = dequeue (Queue (revlst l) []) -- other cases are wrong states

emptyq = (Queue [] []) -- to avoid wrong representation (with both lists full) export this and enqueue/dequeue
                       -- or (as done in sol) just transform those by turning (Queue x y) into (Queue (x ++ reverse y) [])

-- (ii)
instance Foldable Queue where
  foldr f z (Queue l []) = foldr f z l
  foldr f z (Queue [] l) = foldr f z $ revlst l

instance Functor Queue where
  fmap f (Queue l []) = Queue (fmap f l) []
  fmap f (Queue [] l) = Queue [] (fmap f l)

-- (iii)
instance Applicative Queue where
  pure x = (Queue [] [x])
  (Queue [] fl) <*> (Queue [] vl) = (Queue [] (fl <*> vl))
  (Queue fl []) <*> (Queue vl []) = (Queue (fl <*> vl) [])
  (Queue [] fl) <*> (Queue vl []) = (Queue [] (fl <*> (revlst vl)))
  (Queue fl []) <*> (Queue [] vl) = (Queue (fl <*> (revlst vl)) [])

{- TEST
dequeue $ enqueue (Queue [1, 2, 3] []) 4
> (Queue [2,3,4] [],1)
-}

-- TRY IF PROF'S SOLUTION IS BETTER