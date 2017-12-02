#!/usr/bin/env runghc
import Data.Function ((&))
import Data.List (maximum, minimum)

evenlyDivided :: [Int] -> Int
evenlyDivided ints =
    head
        [ d | x <- ints
            , y <- ints
            , let (d, m) = x `quotRem` y
            , m == 0
            , d /= 1
        ]

intoMatrix :: String -> [[Int]]
intoMatrix input =
    lines input
    & map words
    & map (map read)

prog :: String -> String
prog input =
    intoMatrix input
    & map evenlyDivided
    & sum
    & show

main :: IO ()
main = interact prog
