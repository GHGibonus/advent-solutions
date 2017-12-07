#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns, DuplicateRecordFields #-}

import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map, (!))
import Data.Function ((&))

(&>) = flip (.)

type TowerMap = Map String (Int, [String])

data Tower
    = Terminal { name :: String, weight :: Int }
    | Holder { name :: String, weight :: Int, holds :: [Tower] }
    deriving (Show)


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


findRoot :: String -> String
findRoot =
    toTowerMap
    &> mapToTower
    &> name
    &> show

main = interact findRoot
