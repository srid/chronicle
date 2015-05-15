module Controller where

import Signal exposing (Mailbox, mailbox)

import Debug exposing (log)
import Model exposing (Model)


type Action
  = NoOp
  | Initialize (List Model.Feeling)
  | Search String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp                   -> model
    Initialize newFeelings -> { feelings=newFeelings, keywords="" }
    Search keywords        -> let
                                _ = log "Search action" keywords
                              in
                                { model | keywords <- keywords }

actions : Mailbox Action
actions =
  mailbox NoOp
