module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)

import Chronicle.Model exposing (Model)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit


type Action
  = NoOp
  | Search      Search.Action
  | FeelingEdit FeelingEdit.Action
  | FeelingList FeelingList.Action

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    FeelingList a ->
      { model | feelings <- (FeelingList.update a model.feelings) }
    Search a ->
      { model | search <- (Search.update a model.search) }
    FeelingEdit a ->
      { model | feelingEdit <- (FeelingEdit.update a model.feelingEdit) }

actions : Mailbox Action
actions =
  mailbox NoOp
