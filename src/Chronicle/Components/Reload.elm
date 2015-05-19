module Chronicle.Components.Reload where

import String
import Debug exposing (log)

import Chronicle.Components.FeelingList as FeelingList

-- Model

type Model
  = Empty

initialModel : Model
initialModel = Empty

-- Actions

type Action
  = Reload

-- Update

update : Action -> Model -> (Model, Maybe FeelingList.Request)
update action model =
  case action of
    Reload ->
      (model, Just FeelingList.Reload)
