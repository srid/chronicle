module Util.List where

-- Take a sorted list and group it by some key function
groupBy : (a -> b) -> (List a) -> (List (b, (List a)))
groupBy f list =
  case list of
    []       -> []
    hd::tl   -> let
                  key = f hd
                  chunk = takeWhile (\x -> (f x) == key) tl
                  rest = dropWhile (\x -> (f x) == key) tl
                in
                  (key, hd :: chunk) :: groupBy f rest

takeWhile : (a -> Bool) -> (List a) -> (List a)
takeWhile predicate list =
  case list of
    []       -> []
    hd::tl   -> if | (predicate hd) -> hd :: takeWhile predicate tl
                   | otherwise -> []

dropWhile : (a -> Bool) -> (List a) -> (List a)
dropWhile predicate list =
  case list of
    []       -> []
    hd::tl   -> if | (predicate hd) -> dropWhile predicate tl
                   | otherwise -> tl
