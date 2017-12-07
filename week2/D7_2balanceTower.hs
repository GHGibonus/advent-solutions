#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns, DuplicateRecordFields #-}

import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map, (!))
import Data.List (nub)
import Data.Function ((&))

(&>) = flip (.)

type TowerMap = Map String (Int, [String])

data Tower
    = Terminal { name :: String, weight :: Int }
    | Holder { name :: String, weight :: Int, holds :: [Tower] }
    deriving (Show)

instance Eq Tower where
    (==) r l = totalWeight r == totalWeight l

towerDepth :: Tower -> Int
towerDepth Terminal{} = 0
towerDepth Holder{holds} = 1 + foldr1 max (map towerDepth holds)


makeMap :: [(String, Int, [String])] -> TowerMap
makeMap = Map.fromList . map (\(x,y,z) -> (x, (y,z)))


makeTower :: TowerMap -> String -> Tower
makeTower programs name =
    programs ! name
    & (\(x,y) -> (name, x, y))
    & finalizeTower programs

finalizeTower :: TowerMap -> (String, Int, [String]) -> Tower
finalizeTower programs (name, weight, namesHolds) =
    case namesHolds of
        [] ->
            Terminal { name, weight }
        notEmpty ->
            Holder
                { name
                , weight
                , holds = map (makeTower programs) namesHolds
                }


chooseDeepest :: Tower -> Tower -> Tower
chooseDeepest l r =
    if towerDepth l > towerDepth r then l else r

mapToTower :: TowerMap -> Tower
mapToTower programs =
    foldr
        (\cur old -> chooseDeepest old $ makeTower programs cur)
        (Terminal "" 0)
        (Map.keys programs)


toTowerEntry :: String -> (String, Int, [String])
toTowerEntry line =
    case words line of
        [name, weight] ->
            (name, read weight, [])

        name : weight : "->" : heldNames ->
            (name, read weight, map (filter (/= ',')) heldNames)


toTowerMap :: String -> TowerMap
toTowerMap =
    lines
    &> map toTowerEntry
    &> makeMap


totalWeight :: Tower -> Int
totalWeight Terminal{weight} = weight
totalWeight Holder{weight,holds} = weight + (sum $ map totalWeight holds)


data RD a
    = Uninit
    | Unsure a
    | Uniq a
    | Repeated a
    | UnsureTwo a a

detectRepeat :: Eq a => RD a -> a -> RD a
detectRepeat Uninit val = Unsure val
detectRepeat (Unsure old) val | old == val = Repeated old
detectRepeat (Unsure old) val | otherwise  = UnsureTwo old val
detectRepeat (UnsureTwo rep old) val | rep == val = Uniq old
detectRepeat (UnsureTwo old rep) val | rep == val = Uniq old
detectRepeat (Repeated rep) val | rep == val = Repeated rep
detectRepeat (Repeated rep) val | otherwise  = Uniq val
detectRepeat (Uniq x) _ = Uniq x

-- ------ 15153 ------------ 15153 -------------- 15160 ----------
-- Uninit ^^^^^ Unsure 15153 ^^^^^ Repeated 15153 ^^^^^ Uniq 15160

unboxRD :: RD a -> Maybe a
unboxRD (Uniq x) = Just x
unboxRD _ = Nothing

-- Returns the one element of [a] that is not repeated
-- Where there is only one non-repeated element and all other
-- elements have equal values
nonRepeated :: Eq a => [a] -> Maybe a
nonRepeated = unboxRD . foldl detectRepeat Uninit


-- The last tower holding an unbalanced tower
unbalancedHeld :: Tower -> Tower
unbalancedHeld tower@Holder{holds} =
    case nonRepeated holds of
        Just Terminal{} ->
            tower

        Just holdingTower ->
            if isBalanced holdingTower then
                tower
            else
                unbalancedHeld holdingTower

        Nothing ->
            tower

isBalanced :: Tower -> Bool
isBalanced tower = (length $ nub $ map totalWeight $ holds tower) == 1

-- Returns the weight of the unbalanced children after adjustement
balance :: Tower -> Int
balance tower =
    let
        unbalanced = (\(Just x) -> x) $ nonRepeated $ holds $ tower
        unbalancedHoldWeight = sum $ map totalWeight (holds unbalanced)
        balancedWeight = totalWeight $ head $ filter (/= unbalanced) (holds tower)
    in
        balancedWeight - unbalancedHoldWeight


findUnbalancedWeight :: String -> String
findUnbalancedWeight =
    toTowerMap
    &> mapToTower
    &> unbalancedHeld
    &> balance
    &> show

main = interact findUnbalancedWeight
