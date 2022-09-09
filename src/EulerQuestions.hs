{-# LANGUAGE NumericUnderscores #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module EulerQuestions where

import Data.Function
import qualified Data.Map.Strict as Map
import Data.Maybe (fromMaybe)
import Debug.Trace

-- ANCHOR Q1
-- If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
-- Find the sum of all the multiples of 3 or 5 below 1000.
isMultipleOf :: Int -> Int -> Bool
x `isMultipleOf` y = x `rem` y == 0

-- Input 1000 ->
q1 :: Int
q1 =
  sum
    (filter (\x -> x `isMultipleOf` 3 || x `isMultipleOf` 5) [0 .. (1_000 - 1)])

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
q2 =
  fibSeq
    & takeWhile (<= 4_000_000)
    & filter even
    & sum

-- ANCHOR Q3
-- The prime factors of 13195 are 5, 7, 13 and 29.
-- What is the largest prime factor of the number 600851475143 ?
type Factor = Int

type Frequency = Int

updateCounterMap :: Ord k => k -> Map.Map k Frequency -> Map.Map k Frequency
updateCounterMap k = Map.insertWith (+) k 1

primeFactors :: Int -> Map.Map Factor Frequency
primeFactors n =
  primeFactors'
    n
    -- List of numbers of 2 and odd numbers less than sqrt(n)
    (2 : takeWhile (<= (round . sqrt . (fromIntegral :: Int -> Float)) n) [3, 5 ..])
    Map.empty
  where
    -- Check if f can divide n' evenly. If so, update its number in a frequency map,
    -- perform n' = f / n', and try dividing f into the new n'.
    -- If you can't divide evenly, try with the next number in fs.
    -- If you exhaust the list
    primeFactors' n' [] freqMap = if n' > 2 then updateCounterMap n' freqMap else freqMap
    primeFactors' n' (f : fs) freqMap =
      if n' < 2
        then freqMap
        else
          let (d, m) = n' `divMod` f
           in if m == 0
                then primeFactors' d (f : fs) (updateCounterMap f freqMap)
                else primeFactors' n' fs freqMap

q3 :: Factor
q3 = fst $ fromMaybe (0, 0) $ Map.lookupMax $ primeFactors 600_851_475_143

-- ANCHOR Q4
-- A palindromic number reads the same both ways.
-- The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
-- Find the largest palindrome made from the product of two 3-digit numbers.
-- Note: Only works for positive numbers
reverseNumber :: Int -> Int
reverseNumber = reverseNumber' 0
  where
    reverseNumber' acc 0 = acc
    reverseNumber' acc x =
      let (d, m) = x `divMod` 10 in reverseNumber' (acc * 10 + m) d

isNumPalendromic :: Int -> Bool
isNumPalendromic n = n == reverseNumber n

-- Originally used reverseNumber to avoid converting to Lists and then reversing the list, but
-- somehow converting to list -> reversing list was faster!!
q4 :: Int
q4 = maximum [x * y | x <- [100 .. 999], y <- [x .. 999], show (x * y) == reverse (show (x * y))]

-- ANCHOR Q5
-- 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
-- What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

-- Algorithm: Each number can be written as a product of its prime factors.
--            For numbers 1 .. n, create a frequency map of their prime factors;
--            E.g., 8 = {2:3} (Prime factor 2 appears 3 times), 6 = {2:1, 3:1}, 5 = {5:1} (Note that we ignore '1' as a factor)
--            Keep track of a master frequency map, keeping track of the **maximum** number of times a prime factor appears
--            At the end, multiply each prime factor by their maximum occurence to find the answer.
