#!/usr/bin/env runghc
import Data.List (sort, elemIndices)
type Position = Int

spin :: Int -> [Position] -> [Position]
spin offset = map (\pos -> (pos + offset) `mod` 16)

exchange :: Int -> Int -> [Position] -> [Position]
exchange x y = map swapXY
    where
        swapXY pos =
            if pos == x then y
            else if pos == y then x
            else pos

partners :: Int -> Int -> [Position] -> [Position]
partners x y positions = map modifyPartners indexedList
    where
        indexedList = zip [0..] positions
        modifyPartners (i, pos) =
            if i == x then positions !! y
            else if i == y then positions !! x
            else pos

parseArgs :: (Int -> Int -> a) -> (String -> Int) -> String -> a
parseArgs f reader input =
    let (x, '/':y) = span (/= '/') input
    in f (reader x) (reader y)

move :: String -> [Position] -> [Position]
move ('s':offset) = spin $ read offset
move ('x':input)  = exchange `parseArgs` read  $ input
move ('p':input)  = partners `parseArgs` toInt $ input
    where
        toInt = head . flip elemIndices ['a'..'p'] . head

displayDancers :: [Position] -> String
displayDancers = snd . unzip . sort . flip zip ['a'..'p']

splitMoves :: String -> [String]
splitMoves = words . map (\c -> if c == ',' then ' ' else c)

main = interact (displayDancers . foldl (flip move) [0..15] . splitMoves)
