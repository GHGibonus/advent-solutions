#!/usr/bin/env runghc
eatGarbage :: String -> (Integer, String)
eatGarbage = eatGarbo False 0

eatGarbo :: Bool-> Integer -> String -> (Integer, String)
eatGarbo True  acc ( _ :t) = eatGarbo False acc t
eatGarbo False acc ('!':t) = eatGarbo True  acc t
eatGarbo False acc ('>':t) = (acc, t)
eatGarbo False acc ( _ :t) = eatGarbo False (acc+1) t

eatBlock :: Integer -> String -> Integer
eatBlock acc ('{':t) = eatBlock acc t
eatBlock acc ('}':[]) = acc
eatBlock acc ('}':t) = eatBlock acc t
eatBlock acc (',':t) = eatBlock acc t
eatBlock acc ('<':t) = let (cc, t')  = eatGarbage t in eatBlock (acc + cc) t'

main = interact (show . eatBlock 0)
