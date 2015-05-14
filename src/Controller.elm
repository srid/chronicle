module Controller where

import Model exposing (Model)


type alias Action = Maybe Model

update : Action -> Model -> Model
update maybeFeeling feelings = case maybeFeeling of
  Nothing -> feelings
  Just newFeelings -> newFeelings
