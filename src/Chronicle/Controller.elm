module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)

import Chronicle.Model exposing (Model, Feeling)
import Chronicle.Components.Search as SearchComponent


type Action
  = NoOp
  | Initialize (List Feeling)
  | Search SearchComponent.Action
  | Add String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp                   ->
      model
    Initialize newFeelings ->
      { feelings=newFeelings, search=SearchComponent.initialModel }
    Search a ->
      { model | search <- (SearchComponent.update a model.search) }
    Add what ->
      let
        _ = log "Add action" what
     in
       model

actions : Mailbox Action
actions =
  mailbox NoOp
