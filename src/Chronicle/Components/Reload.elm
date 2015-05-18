module Chronicle.Components.Reload where

import String
import Debug exposing (log)

-- Model

type Model
  = Empty

initialModel : Model
initialModel = Empty

-- Actions

type Action
  = Reload

-- Update

update : Action -> Model -> Model
update action model =
  case action of
    Reload ->
      let
        _ = log "[Reload] Reloading" model
      in
        model
