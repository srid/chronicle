module Util.Text where

import String exposing (words, join, reverse, toLower)
import Set
import Set exposing (Set)

mangleText : Set String -> String -> String
mangleText whitelist text =
  words text
  |> List.map (mangleWord whitelist)
  |> join " "

mangleWord : Set String -> String -> String
mangleWord whitelist word =
  case Set.member (toLower word) whitelist of
    True  -> word
    False -> mangle word

mangle : String -> String
mangle string =
  reverse string -- TODO: actually mangle
