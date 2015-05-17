module Chronicle.Search where

import String

-- Search complexity is O(n), assuming small number of keywords.
-- Eventually we have to let postgresql handle the searching.
search : String -> (a -> String) -> List a -> List a
search keywords valueToString =
  let
    keywordsList = (String.words keywords)
  in
    List.filter (\x -> List.all (matchValue <| valueToString x) keywordsList)

matchValue : String -> String -> Bool
matchValue value keywords =
  let
    keywords' = String.toLower keywords
    text      = String.toLower value
  in
    String.contains keywords' text
