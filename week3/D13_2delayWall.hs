#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}
import Data.Function ((&))

data Wall = Wall { layer :: Int, height :: Int }
(%) = mod; infixl 5%

caughtAt delay Wall{layer, height} =
    layer + delay % (height - 1) * 2 == 0

intoWall input =
    filter (/= ':') input
    & words
    & \[layer, height] -> Wall (read layer) (read height)

intoFireWall             = map intoWall . lines
succeeds        delay    = all (not . caughtAt delay)
succeedingDelay fireWall = head $ dropWhile (not . flip succeeds fireWall) [0..]

main = interact (show . succeedingDelay . intoFireWall)
