module Chronicle.Components.Search where

import String
import Debug exposing (log)

-- Model

type Model
  = Keywords (List String)

initialModel : Model
initialModel = Keywords []

-- Actions

type Action
  = SearchFor String

-- Update

update : Action -> Model -> Model
update action model =
  case action of
    SearchFor keywords ->
      String.words keywords |> Keywords

-- Search complexity is O(n), assuming small number of keywords.
-- Eventually we have to let postgresql handle the searching.
search : Model -> (a -> String) -> List a -> List a
search (Keywords keywords) valueToString =
  List.filter (\x -> List.all (matchValue <| valueToString x) keywords)

matchValue : String -> String -> Bool
matchValue value keywords =
  let
    keywords' = String.toLower keywords
    text      = String.toLower value
  in
    String.contains keywords' text
