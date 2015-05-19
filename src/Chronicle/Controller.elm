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

type Request
  = FeelingListRequest FeelingList.Request
  | FeelingEditRequest FeelingEdit.Request

initialRequest : Request
initialRequest = FeelingListRequest FeelingList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (FeelingListRequest r') -> Task.map FeelingList <| FeelingList.run r'
    (FeelingEditRequest r') -> Task.map Reload <| FeelingEdit.run r'

justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    NoOp ->
      justModel model
    Search a ->
      justModel { model | search <- (Search.update a model.search) }
    Reload a ->
      let
        (searchModel, maybeRequest) = Reload.update a model.reload
      in
        ({ model | reload <- searchModel }, Maybe.map FeelingListRequest maybeRequest)
    FeelingList a ->
      justModel { model | feelings <- (FeelingList.update a model.feelings) }
    FeelingEdit a ->
      let
        (editModel, maybeRequest) = FeelingEdit.update a model.feelingEdit
      in
        ({model | feelingEdit <- editModel }, Maybe.map FeelingEditRequest maybeRequest)

actions : Mailbox Action
actions =
  mailbox NoOp
