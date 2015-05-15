--------------------------
-- CORE LIBRARY IMPORTS --
--------------------------
import Task         exposing (Task, ThreadID, andThen, sequence, succeed, spawn, onError)
import Json.Decode  exposing (Decoder, list, int, string, (:=), map, object2)
import Signal       exposing (Signal, Mailbox, mailbox, send)
import List

---------------------------------
-- THIRD PARTY LIBRARY IMPORTS --
---------------------------------
import Html             exposing (Html, div, span, ul, li, a, em, strong, text)
import Html.Attributes  exposing (href)
import Http             exposing (Error, get)

import Model exposing (Model, Feeling)
import View
import Controller
import Database
import App



initialModel : Model
initialModel = []


mainTaskMailbox : Mailbox (Task Error ())
mainTaskMailbox =
  mailbox Database.getFeelings

port mainTaskPort : Signal (Task Error ())
port mainTaskPort =
  mainTaskMailbox.signal


{--
actions : Signal Controller.Action
actions =
  .signal Database.feelingsMailbox
  --}


----------
-- MAIN --
----------

main : Signal Html
main = App.start { model = initialModel
                 , view = View.view
                 , update = Controller.update }

{-- omain : Signal Html
omain =
  Signal.map (View.view <| .address Database.feelingsMailbox)
    ( Signal.foldp Controller.update initialModel actions )
    --}
