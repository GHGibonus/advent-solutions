#!/usr/bin/env runghc
import Data.List (sort)

hasDuplicatesHelper :: Eq a => [a] -> Bool
hasDuplicatesHelper []        = False
hasDuplicatesHelper [_]       = False
hasDuplicatesHelper (x:x':xs) = x == x' || hasDuplicatesHelper (x':xs)

hasDuplicates :: Eq a => Ord a => [a] -> Bool
hasDuplicates = hasDuplicatesHelper . sort

checkPasses :: [[String]] -> Int
checkPasses = sum . map (\x -> if hasDuplicates x then 0 else 1)

main :: IO ()
main = interact (show . checkPasses . map words . lines)

