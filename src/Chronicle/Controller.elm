module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)

import Chronicle.Model exposing (Model, Feeling)


type Action
  = NoOp
  | Initialize (List Feeling)
  | Search String
  | Add String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp                   -> model
    Initialize newFeelings -> { feelings=newFeelings, keywords="" }
    Search keywords        -> let
                                _ = log "Search action" keywords
                              in
                                { model | keywords <- keywords }
    Add what               -> let
                                _ = log "Add action" what
                              in
                                model
actions : Mailbox Action
actions =
  mailbox NoOp
