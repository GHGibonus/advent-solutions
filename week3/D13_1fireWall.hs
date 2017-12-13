#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}
import Data.Maybe (mapMaybe)
import Data.Function ((&))

data Wall = Wall { layer :: Int, height :: Int }
type Severity = Int
(%) = mod; infixl 5%

caughtAt :: Wall -> Maybe Severity
caughtAt Wall{layer, height} =
    if layer % (height - 1) * 2 == 0
        then Just $ layer * height
        else Nothing

intoWall :: String -> Wall
intoWall input =
    filter (/= ':') input
    & words
    & (\[layer, height] -> Wall (read layer) (read height))

intoFireWall :: String -> [Wall]
intoFireWall = map intoWall . lines

traverseWall :: [Wall] -> Severity
traverseWall = sum . mapMaybe caughtAt

main = interact (show . traverseWall . intoFireWall)
