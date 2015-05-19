module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task)
import Task
import Http

import Chronicle.Model exposing (Model)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Components.Search as Search
import Chronicle.Components.Reload as Reload
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit


type Action
  = NoOp
  | Search      Search.Action
  | FeelingEdit FeelingEdit.Action
  | FeelingList FeelingList.Action
  | Reload      Reload.Action

type Request = Request Action

initialRequest : Request
initialRequest = Request NoOp

run : Request -> Task Http.Error Action
run r =
  let _ = log "Running request" r
  in
  case r of
    (Request NoOp) -> Task.succeed NoOp

type alias Update = Action -> Model -> (Model, Maybe Request)

-- Temporary wrapper until we change all update functions.
update : Update
update =
  (\a m -> (update0 a m, Nothing))

update0 : Action -> Model -> Model
update0 action model =
  case action of
    NoOp ->
      model
    Search a ->
      { model | search <- (Search.update a model.search) }
    Reload a ->
      { model | reload <- (Reload.update a model.reload) }
    FeelingList a ->
      { model | feelings <- (FeelingList.update a model.feelings) }
    FeelingEdit a ->
      { model | feelingEdit <- (FeelingEdit.update a model.feelingEdit) }

actions : Mailbox Action
actions =
  mailbox NoOp
