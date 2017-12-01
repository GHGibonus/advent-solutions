#!/usr/bin/env runghc
import Data.Function ((&))

sumNub :: Int -> (Int,Int) -> (Int,Int)
sumNub current (last_number,acc) =
    ( current
    , acc + if last_number == current then current else 0
    )

sumDuplicates :: String -> String
sumDuplicates input =
    map (read . pure) input
    & (\(h:t) -> foldr sumNub (h,0) (h:t))
    & snd
    & show

main :: IO ()
main = interact sumDuplicates

