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
      { feelings=newFeelings, keywords=SearchComponent.initialModel }
    Search a ->
      let
        _ = log "Search action" a
      in
        { model | keywords <- (SearchComponent.update a model.keywords) }
    Add what ->
      let
        _ = log "Add action" what
     in
       model

actions : Mailbox Action
actions =
  mailbox NoOp
