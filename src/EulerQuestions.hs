{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE NumericUnderscores #-}
module EulerQuestions where

import Data.Function
import Data.Numbers.Prime
-- ANCHOR Q1
-- If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
-- Find the sum of all the multiples of 3 or 5 below 1000.
isMultipleOf :: Int -> Int -> Bool
x `isMultipleOf` y = x `rem` y == 0

-- Input 1000 -> 
q1 :: Int
q1 = sum (filter  (\x -> x `isMultipleOf` 3 || x `isMultipleOf` 5) [0 .. (1000 - 1)])

-- ANCHOR Q2
-- Each new term in the Fibonacci sequence is generated by adding the previous two terms. 
-- By starting with 1 and 2, the first 10 terms will be:
-- 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
-- By considering the terms in the Fibonacci sequence whose values do not exceed four million, 
-- find the sum of the even-valued terms.
fibSeq :: [Int]
-- Elegant recursive solution; fibSeq if f(n - 2), and (tail fibSeq) is f(n - 1). This 
-- is because we are defining the recursive part starting at the 3rd element
fibSeq = 1 : 2 : zipWith (+) fibSeq (tail fibSeq)

q2 :: Int
q2 = fibSeq & takeWhile (<= 4_000_000) & filter even & sum 


-- ANCHOR Q3
-- !! SKIP

