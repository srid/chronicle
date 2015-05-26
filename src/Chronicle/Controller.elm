module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task, andThen)
import Task
import Http

import Util.Component exposing (delegateTo)
import Chronicle.Model exposing (Model)
import Chronicle.Data.Moment exposing (Moment)
import Chronicle.Components.Search as Search
import Chronicle.Components.MomentList as MomentList

-- Action

type Action
  = NoOp
  | Search      Search.Action
  | MomentList MomentList.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    NoOp ->
      justModel model
    Search a ->
      justModel { model | search <- (Search.update a model.search) }
    MomentList a ->
      delegateTo
        MomentList.update
        (\m -> { model | momentList <- m })
        (Maybe.map MomentListRequest)
        a
        model.momentList
-- Request

type Request
  = MomentListRequest MomentList.Request

initialRequest : Request
initialRequest = MomentListRequest MomentList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (MomentListRequest r') ->
      Task.map MomentList <| MomentList.run r'

actions : Mailbox Action
actions =
  mailbox NoOp

-- Component utility
justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)
