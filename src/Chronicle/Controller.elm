module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task, andThen)
import Task
import Http

import Util.Component exposing (delegateTo)
import Chronicle.Model exposing (Model)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList

-- Action

type Action
  = NoOp
  | Search      Search.Action
  | FeelingList FeelingList.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    NoOp ->
      justModel model
    Search a ->
      justModel { model | search <- (Search.update a model.search) }
    FeelingList a ->
      delegateTo
        FeelingList.update
        (\m -> { model | feelingList <- m })
        (Maybe.map FeelingListRequest)
        a
        model.feelingList
-- Request

type Request
  = FeelingListRequest FeelingList.Request

initialRequest : Request
initialRequest = FeelingListRequest FeelingList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (FeelingListRequest r') ->
      Task.map FeelingList <| FeelingList.run r'

actions : Mailbox Action
actions =
  mailbox NoOp

-- Component utility
justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)
