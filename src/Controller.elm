module Controller where

import Signal exposing (Mailbox, mailbox)

import Debug exposing (log)
import Model exposing (Model)


type Action
  = NoOp
  | Initialize Model
  | Search String

update : Action -> Model -> Model
update action feelings =
  case action of
    NoOp                   -> feelings
    Initialize newFeelings -> newFeelings
    Search keywords        -> let _ = log "Search action" keywords in feelings

actions : Mailbox Action
actions =
  mailbox NoOp
