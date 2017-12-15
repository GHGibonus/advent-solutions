import Data.Function ((&))
import Data.Bits ((.&.))

generator modulus factor = flip mod modulus . (*) factor

genA' a | a `mod` 4 == 0 = a
genA' a | otherwise      = genA' $ generator 2147483647 16807 a
genA = genA' . generator 2147483647 16807

genB' b | b `mod` 8 == 0 = b
genB' b | otherwise      = genB' $ generator 2147483647 48271 b
genB = genB' . generator 2147483647 48271

judge startA startB =
    let
        zipAB (a,b) = (genA a, genB b)
        numberStream = iterate zipAB (startA, startB)
        suffixEqual (x,y) = if (0xffff .&. x) == (0xffff .&. y) then 1 else 0
        fiveMillion = 5 * 10^6
    in
        map suffixEqual numberStream
        & take fiveMillion
        & sum

readStarts :: String -> (Int, Int)
readStarts = (\[sa,sb] -> (sa, sb)) . map (read . last . words) . lines

main = interact (show . uncurry judge . readStarts)
