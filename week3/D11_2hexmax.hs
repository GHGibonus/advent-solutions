#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}
import Data.Function ((&))

data Direction = NW | N | NE | SE | S | SW

data Coord = Coord { x :: Int, y :: Int } deriving (Show)

move :: Direction -> Coord -> Coord
move NW Coord{x,y} = Coord { x = x - 1, y = y + if odd x then 1 else 0 }
move N  Coord{x,y} = Coord { x = x    , y = y + 1 }
move NE Coord{x,y} = Coord { x = x + 1, y = y + if odd x then 1 else 0 }
move SE Coord{x,y} = Coord { x = x + 1, y = y - if even x then 1 else 0 }
move S  Coord{x,y} = Coord { x = x    , y = y - 1 }
move SW Coord{x,y} = Coord { x = x - 1, y = y - if even x then 1 else 0 }

toDir :: String -> Direction
toDir strDir = case strDir of
   { "nw"->NW ; "n"->N ; "ne"->NE ; "se"->SE ; "s"->S ; "sw"->SW }

distanceToCenter' :: Int -> Coord -> Int
distanceToCenter' acc Coord{x=0,y  } = acc + abs y
distanceToCenter' acc Coord{x  ,y=0} = acc + abs x
distanceToCenter' acc coords@Coord{x,y}
    | x > 0 && y > 0 = distDir SW -- Q + +
    | x < 0 && y > 0 = distDir SE -- Q - +
    | x > 0 && y < 0 = distDir NW -- Q + -
    | otherwise      = distDir NE -- Q - -
    where
        distDir dir = distanceToCenter' (acc + 1) (move dir coords)

distanceToCenter :: Coord -> Int
distanceToCenter = distanceToCenter' 0

solveThis :: String -> String
solveThis input =
    map (\x -> if x == ',' then ' ' else x) input
    & words
    & map toDir
    & scanl (flip move) (Coord 0 0)
    & map distanceToCenter
    & maximum
    & show

main = interact solveThis
