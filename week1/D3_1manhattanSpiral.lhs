#!/usr/bin/env runghc

The ulam spiral has on its diagonal (up left to down right) the following
series (starting from the center): 1 2 4 9 16 25 36 49 64 ...
Any advised person will recognize the squares of natural numbers (also called
series of perfect squares) starting from 4.

We need to find the distance of any cell from the `1` cell (center), so lets
concider the matrix of number in a coordinate system which center is the
center of the board.

In those coordinates, the diagonal on which the squares are located have
the following x and y coordinates:

 root| 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|
    x| 0| 1| 0| 1|-1| 2|-2| 3|-3| 4|-4| 5|
    y| 0| 0| 1|-1| 2|-2| 3|-3| 4|-4| 5|-5|

we have two functions, xCoord and yCoord, respectively returning the x and y
coordinate location of a given root. We observe that we can
implement yCoord in terms of xCoord:

> yCoord 0    = 0
> yCoord root = xCoord $ root - 1

Defining xCoord is the tricky part.  With a bit of cleverness,
we find a simple equation for even numbers:

> xCoord root
>  | even root = negate $ div root 2

For the odd numbers, we have:

>  | otherwise = div root 2

Now that we have the coordinates of the perfect squares, we need to identify
the closest perfect square of a number, and its offset from it.

First though, we need to define a square root function over integers:

> squareRoot = round . sqrt . (fromIntegral :: Integer -> Double)

We can use this to find the root of the closest perfect square.
The output of the function is the combination of the root and the distance
to the perfect square:

> closestPerfectRoot x =
>     let closestRoot = squareRoot x
>     in (closestRoot, x - closestRoot ^ 2)

Note that the distance is "directed" such as if the number is before its
closest perfect square, the distance is negative, otherwise it is positive.

Since the perfect squares are at the diagonals of the grid, and any number
after or before a perfect square are on the same line or same column, we can
judge the grid coordinate of any number.

first we define an helper:

> cellHelper op diff (rootX, rootY)
>  | diff > 0 = (rootX `op` 1, rootY `op` (diff - 1))
>  | otherwise = (rootX `op` diff, rootY)

`op` helps parametrize the function over the direction of the sequence
(coming from right going down if we are on the upper left section,
coming from left going up if we are on the lower right section)

The actual function accepts a root and the difference to the cell of the root,
and returns the (x,y) location of the cell located at diff from root:

> cell root diff =
>     let
>         x = xCoord root
>         y = yCoord root
>     in
>         cellHelper (if even root then (-) else (+)) diff (x, y)

Now we can estimate the cell location of any number:

> cellLocation = uncurry cell . closestPerfectRoot

Finally, we get the manhattan distance from the center (coordinates (0,0)),
which is the aboslute value of the coordinates.

> distanceFromCenter num =
>     let (x,y) = cellLocation num
>     in abs x + abs y

For posterity, we make this function a piping program (stdin -> stdout)

> main :: IO ()
> main = interact (show . distanceFromCenter . read)
