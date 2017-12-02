#!/usr/bin/env runghc
import Data.Function ((&))
import Data.List (maximum, minimum)

minMaxs :: [Int] -> Int
minMaxs ints =
    maximum ints - minimum ints

intoMatrix :: String -> [[Int]]
intoMatrix input =
    lines input
    & map words
    & map (map read)

prog :: String -> String
prog input =
    intoMatrix input
    & map minMaxs
    & sum
    & show

main :: IO ()
main = interact prog
