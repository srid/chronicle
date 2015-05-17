import Task         exposing (Task)
import Signal       exposing (Signal, mailbox)
import List

import Http
import Html exposing (Html)

import Util.App as App
import Chronicle.Model as Model
import Chronicle.View as View
import Chronicle.Controller as Controller
import Chronicle.Database as Database

port mainTaskPort : Signal (Task Http.Error ())
port mainTaskPort =
  .signal <| mailbox Database.getFeelings

main : Signal Html
main = App.start { model = Model.initialModel
                 , view = View.view
                 , update = Controller.update
                 , actions = Controller.actions }
