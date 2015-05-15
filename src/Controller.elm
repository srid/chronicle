module Controller where

import Debug exposing (log)
import Model exposing (Model)


type Action
  = Start
  | Initialize Model

update : Action -> Model -> Model
update action feelings =
  case action of
    Start                  -> log "Controller.Start" <| feelings
    Initialize newFeelings -> newFeelings
