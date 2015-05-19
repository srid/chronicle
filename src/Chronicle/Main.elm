import Task         exposing (Task, andThen)
import Signal       exposing (Signal)
import Signal
import List

import Http
import Html exposing (Html)

import Chronicle.Model as Model
import Chronicle.Model exposing (Model)
import Chronicle.View as View
import Chronicle.Controller as Controller
import Chronicle.Controller exposing (actions, update, Update)
import Chronicle.Database as Database


main : Signal Html
main =
  Signal.map (View.view actions.address) model

model' : Signal (Model, Maybe Controller.Request)
model' =
  Signal.foldp (\a (m, _) -> update a m) (Model.initialModel, Nothing) actions.signal

model : Signal Model
model =
  Signal.map fst model'

requestMaybe : Signal (Maybe Controller.Request)
requestMaybe =
  Signal.map snd model'

request : Signal Controller.Request
request =
  Signal.filterMap id Controller.initialRequest requestMaybe

id : a -> a
id x =
  x

runAndSend : Controller.Request -> Task Http.Error ()
runAndSend r =
  Controller.run r `andThen`
    Signal.send (.address Controller.actions)

port requestPort : Signal (Task Http.Error ())
port requestPort =
  Signal.map runAndSend request


-- XXX: Leverage Request runs to do this..
port mainTaskPort : Signal (Task Http.Error ())
port mainTaskPort =
  .signal <| Signal.mailbox Database.getFeelings
