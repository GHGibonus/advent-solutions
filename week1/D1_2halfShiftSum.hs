#!/usr/bin/env runghc
import Data.Function ((&))

shiftList :: [a] -> [a]
shiftList list =
    let
        len = length list
        (half1, half2) = splitAt (div len 2) list
    in
        half2 ++ half1

sumNub :: (Int,Int) -> Int -> Int
sumNub (current,shifted) =
    (+) (if current == shifted then current else 0)

sumDuplicates :: String -> String
sumDuplicates input =
    map (read . pure) input
    & (\unshift -> let shift = shiftList unshift in zip unshift shift)
    & foldr sumNub 0
    & show

main :: IO ()
main = interact sumDuplicates

