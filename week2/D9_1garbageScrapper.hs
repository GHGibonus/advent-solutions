#!/usr/bin/env runghc
eatGarbage :: String -> String
eatGarbage = eatGarbo False

eatGarbo :: Bool-> String -> String
eatGarbo True  ( _ :t) = eatGarbo False t
eatGarbo False ('!':t) = eatGarbo True  t
eatGarbo False ('>':t) = t
eatGarbo False ( _ :t) = eatGarbo False t

eatBlock :: Integer -> Integer -> String -> Integer
eatBlock acc depth ('{':t) = eatBlock acc (depth+1) t
eatBlock acc depth ('}':[]) = acc + depth
eatBlock acc depth ('}':t) = eatBlock (acc + depth) (depth-1) t
eatBlock acc depth (',':t) = eatBlock acc depth t
eatBlock acc depth ('<':t) = eatBlock acc depth $ eatGarbage t

main = interact (show . eatBlock 0 0)
