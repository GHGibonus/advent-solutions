import Data.Function ((&))
import Data.Bits ((.&.))

generator modulus factor = flip mod modulus . (*) factor

genA = generator 2147483647 16807
genB = generator 2147483647 48271

judge startA startB =
    let
        zipAB (a,b) = (genA a, genB b)
        numberStream = iterate zipAB (startA, startB)
        suffixEqual (x,y) = if (0xffff .&. x) == (0xffff .&. y) then 1 else 0
        fourtyMillion = 4 * 10^7
    in
        map suffixEqual numberStream
        & take fourtyMillion
        & sum

readStarts :: String -> (Int, Int)
readStarts = (\[sa,sb] -> (sa, sb)) . map (read . last . words) . lines

main = interact (show . uncurry judge . readStarts)
