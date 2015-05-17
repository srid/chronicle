module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)

import Chronicle.Model exposing (Model)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList


type Action
  = NoOp
  | FeelingList FeelingList.Action
  | Search Search.Action
  | Add String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    FeelingList a ->
      { model | feelings <- (FeelingList.update a model.feelings) }
    Search a ->
      { model | search <- (Search.update a model.search) }
    Add what ->
      let
        _ = log "Add action" what
     in
       model

actions : Mailbox Action
actions =
  mailbox NoOp
