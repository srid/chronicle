module Controller where

import Signal exposing (Mailbox, mailbox)

import Debug exposing (log)
import Model exposing (Model)


type Action
  = NoOp
  | Initialize Model

update : Action -> Model -> Model
update action feelings =
  case action of
    NoOp                   -> log "Controller.NoOp" <| feelings
    Initialize newFeelings -> newFeelings

actions : Mailbox Action
actions =
  mailbox NoOp
