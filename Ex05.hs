--By Jonathan Williams z5162987

module Ex05 where

import Text.Read (readMaybe)
import Control.Monad

data Token = Number Int | Operator (Int -> Int -> Int)

parseToken :: String -> Maybe Token
parseToken "+" = Just (Operator (+))
parseToken "-" = Just (Operator (-))
parseToken "/" = Just (Operator div)
parseToken "*" = Just (Operator (*))
parseToken str = fmap Number (readMaybe str)


tokenise :: String -> Maybe [Token]
tokenise s = sequence $ fmap parseToken ws
  where
    ws :: [String]
    ws = words s


newtype Calc a = C ([Int] -> Maybe ([Int], a))


pop :: Calc Int
pop = C poop
  where
    poop :: [Int] -> Maybe ([Int], Int)
    poop [] = Nothing
    poop (x:xs) = Just (xs, x)

push :: Int -> Calc ()
push i = C puup
  where
    puup :: ([Int] -> Maybe ([Int], ()))
    puup is = Just (i:is, ())


instance Functor Calc where
  fmap f (C sa) = C $ \s ->
      case sa s of 
        Nothing      -> Nothing
        Just (s', a) -> Just (s', f a)

instance Applicative Calc where
  pure x = C (\s -> Just (s,x))
  C sf <*> C sx = C $ \s -> 
      case sf s of 
          Nothing     -> Nothing
          Just (s',f) -> case sx s' of
              Nothing      -> Nothing
              Just (s'',x) -> Just (s'', f x)

instance Monad Calc where
  return = pure
  C sa >>= f = C $ \s -> 
      case sa s of 
          Nothing     -> Nothing
          Just (s',a) -> unwrapCalc (f a) s'
    where unwrapCalc (C a) = a

evaluate :: [Token] -> Calc Int
evaluate [] = do
  x <- pop
  pure x
evaluate ((Number n):ts) = do
  push n
  evaluate ts
evaluate ((Operator o):ts) = do
  x <- pop
  y <- pop
  push (o y x)
  evaluate ts

--tokenise :: String -> Maybe [Token]
--evaluate :: [Token] -> Calc Int
--newtype Calc a = C ([Int] -> Maybe ([Int], a))
calculate :: String -> Maybe Int
calculate s = do
  ts <- tokenise s -- [Token]
  let comp = evaluate ts -- Calc Int :: C ([Int] -> Maybe ([Int], Int))
  let (C f) = comp
  x <- fmap snd $ f []  -- fmap snd Maybe ([Int], Int)
  return x

