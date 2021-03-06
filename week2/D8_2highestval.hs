#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}
import qualified Data.Map.Strict as Map
import Data.Maybe (fromMaybe)

type CPU = Map.Map String Int

data Instruction =
    Instruction
        { target :: String
        , by :: Int
        , cmpReg :: String
        , cmpOp :: (Int -> Bool)
        }


parseInstruction :: String -> Instruction
parseInstruction instrs =
    case words instrs of
        [ reg, "inc", ammount, "if", cmpReg, compOp, compVal] ->
            Instruction
                { target = reg
                , by = read ammount
                , cmpReg
                , cmpOp = toComp compOp $ read compVal
                }

        [ reg, "dec", ammount, "if", cmpReg, compOp, compVal] ->
            Instruction
                { target = reg
                , by = negate $ read ammount
                , cmpReg
                , cmpOp = toComp compOp $ read compVal
                }
    where
        toComp "!=" = flip (/=)
        toComp "<"  = flip (<)
        toComp "<=" = flip (<=)
        toComp "==" = flip (==)
        toComp ">"  = flip (>)
        toComp ">=" = flip (>=)


execInstr :: Instruction -> CPU -> CPU
execInstr Instruction{target, by, cmpReg, cmpOp} cpu =
    Map.alter updateCPU target cpu
    where
        updateCPU :: Maybe Int -> Maybe Int
        updateCPU oldReg = Just $
            fromMaybe 0 oldReg +
                if cmpOp $ Map.findWithDefault 0 cmpReg cpu then by else 0


execProgram :: String -> String
execProgram prog =
    show $ snd $ foldl updateCPU (Map.empty, 0) (lines prog)
    where
        updateCPU (cpu, curMax) instr =
            let updatedCPU = execInstr (parseInstruction instr) cpu
            in (updatedCPU, max curMax (mapMax updatedCPU))

        mapMax map = maximum $ Map.elems map


main = interact execProgram
