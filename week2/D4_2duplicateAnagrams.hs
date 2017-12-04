#!/usr/bin/env runghc
import Data.List (sort)

hasDuplicatesHelper :: Eq a => [a] -> Bool
hasDuplicatesHelper []        = False
hasDuplicatesHelper [_]       = False
hasDuplicatesHelper (x:x':xs) = x == x' || hasDuplicatesHelper (x':xs)

hasDuplicateAnagrams :: [String] -> Bool
hasDuplicateAnagrams = hasDuplicatesHelper . sort . map sort

checkPasses :: [[String]] -> Int
checkPasses = sum . map (\x -> if hasDuplicateAnagrams x then 0 else 1)

main :: IO ()
main = interact (show . checkPasses . map words . lines)

