import Task         exposing (Task)
import Signal       exposing (Signal)
import Signal
import List

import Http
import Html exposing (Html)

import Chronicle.Model as Model
import Chronicle.Model exposing (Model)
import Chronicle.View as View
import Chronicle.Controller exposing (actions, update)
import Chronicle.Database as Database


main : Signal Html
main =
  Signal.map (View.view actions.address) model

model : Signal Model
model =
  Signal.foldp update Model.initialModel actions.signal

port mainTaskPort : Signal (Task Http.Error ())
port mainTaskPort =
  .signal <| Signal.mailbox Database.getFeelings
