#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}

import Data.Array (Array,array,(!), indices, listArray, (//))

type MatArray = Array Int (Array Int Int)
data Matrix =
    Matrix
        { matrix :: MatArray
        , pointer :: (Int,Int)
        }
    deriving(Show)

index :: Matrix -> (Int, Int) -> Int
index Matrix{matrix} (x,y) =
    matrix ! x ! y

updateMatArray :: (Int, Int) -> Int -> MatArray -> MatArray
updateMatArray (x,y) val matrix =
    let oldRow = matrix ! x
    in matrix // [(x,(oldRow // [(y,val)]))]

initMat :: Matrix
initMat =
    let
        size = 25
        row = array (-size, size) [(i, 0) | i <- [(-size) + 1..size]]
        matrix' = array (-size, size) [(i, row) | i <- [(-size) + 1..size]]
    in
        Matrix
            { matrix = updateMatArray (0,0) 1 matrix'
            , pointer = (1,0)
            }

{-| We divide the matrix in four quadrants, which demarcations are the
    functions f(x) = x and f(x) = -x

    We select the direction of the pointer according to which quardrant
    the current pointer is:
    * top    quadrant Q1: go leftward
    * left   quadrant Q2: go downward
    * bottom quadrant Q3: go rightward
    * right  quadrant Q4: go upward

    Pointer is in the given quadrant IF:
    Q1 if y >= x && y >  -x
    Q2 if y >  x && y <= -x
    Q3 if y <= x && y <= -x
    Q4 if y <  x && y >  -x
-}
movePointer :: (Int, Int) -> (Int, Int)
movePointer (0, 0) = (1, 0)
movePointer (1, 0) = (1, 1)
movePointer (x, y)
    | y >= x && y >  -x = (x - 1, y)
    | y >  x && y <= -x = (x, y - 1)
    | y <= x && y <= -x = (x + 1, y)
    | y <  x && y >  -x = (x, y + 1)
    | otherwise = undefined


computeStep :: Matrix -> Int
computeStep m@Matrix{pointer=(px,py)} =
    let
        idx = index m
        idxs = [(x,y) | x <- [px-1..px+1] , y <- [py-1..py+1]]
    in
        sum $ map idx idxs

step :: Matrix -> (Int, Matrix)
step m@Matrix{matrix,pointer} =
    let
        pointerVal = computeStep m
        nextLoc = movePointer pointer
        nextMat =
            Matrix
                { matrix = updateMatArray pointer pointerVal matrix
                , pointer = nextLoc
                }
    in
        (pointerVal, nextMat)

loopMatrix = iterate (step . snd) (0, initMat)

iterateUpTo :: Int -> Int
iterateUpTo bound =
    fst $ head $ dropWhile ((>=) bound . fst) loopMatrix

main :: IO ()
main = interact (show . iterateUpTo . read)
