module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task, andThen)
import Task
import Http

import Util.Component exposing (updateInner)
import Chronicle.Model exposing (Model)
import Chronicle.Data.Moment exposing (Moment)
import Chronicle.Components.Search as Search
import Chronicle.Components.MomentList as MomentList
import Chronicle.Components.MomentEdit as MomentEdit

-- Action

type Action
  = NoOp
  | Search      Search.Action
  | MomentList MomentList.Action
  | MomentEdit MomentEdit.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    NoOp ->
      justModel model
    Search a ->
      justModel { model | search <- (Search.update a model.search) }
    MomentList a ->
      updateInner
        MomentList.update
        MomentListRequest
        (\m -> { model | momentList <- m })
        a
        model.momentList
    MomentEdit a ->
      updateInner
        MomentEdit.update
        MomentEditRequest
        (\m -> { model | addMoment <- m })
        a
        model.addMoment

-- Request

type Request
  = MomentListRequest MomentList.Request
  | MomentEditRequest MomentEdit.Request

initialRequest : Request
initialRequest = MomentListRequest MomentList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (MomentListRequest r') ->
      Task.map MomentList <| MomentList.run r'
    (MomentEditRequest r') ->
      Task.map MomentList
      <| MomentEdit.run r' `andThen`
          (always <| MomentList.run MomentList.Reload)

actions : Mailbox Action
actions =
  mailbox NoOp

-- Component utility
justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)
