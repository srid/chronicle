import Task         exposing (Task, andThen)
import Signal       exposing (Signal)
import Signal
import List
import Debug exposing (log)

import Http
import Html exposing (Html)

import Chronicle.Model as Model
import Chronicle.Model exposing (Model)
import Chronicle.View as View
import Chronicle.Controller as Controller
import Chronicle.Controller exposing (actions, update)
import Chronicle.Database as Database


main : Signal Html
main =
  Signal.map (View.view actions.address) model

model' : Signal (Model, Maybe Controller.Request)
model' =
  let
    f a (m, _) = update (log "Received action" a) m
  in
  Signal.foldp f (Model.initialModel, Nothing) actions.signal

model : Signal Model
model =
  Signal.map fst model'

request : Signal Controller.Request
request =
  Signal.map snd model'
  |> Signal.filterMap (\x -> x) Controller.initialRequest

runAndSend : Signal.Mailbox Controller.Action -> Controller.Request -> Task Http.Error ()
runAndSend mailbox r =
  Controller.run (log "Running request" r)
    `andThen` Signal.send mailbox.address

port requestPort : Signal (Task Http.Error ())
port requestPort =
  Signal.map (runAndSend Controller.actions) request
