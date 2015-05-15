import Task         exposing (Task)
import Signal       exposing (Signal, mailbox)
import List

import Http
import Html exposing (Html)

import Model
import View
import Controller
import Database
import App



port mainTaskPort : Signal (Task Http.Error ())
port mainTaskPort =
  .signal <| mailbox Database.getFeelings

main : Signal Html
main = App.start { model = Model.initialModel
                 , view = View.view
                 , update = Controller.update
                 , actions = Controller.actions }
