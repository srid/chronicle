module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task)
import Task
import Http

import Chronicle.Model exposing (Model)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit

-- Action

type Action
  = NoOp
  | Search      Search.Action
  | FeelingEdit FeelingEdit.Action
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
    FeelingEdit a ->
      delegateTo
        FeelingEdit.update
        (\m -> { model | feelingEdit <- m })
        (Maybe.map FeelingEditRequest)
        a
        model.feelingEdit

-- Request

type Request
  = FeelingListRequest FeelingList.Request
  | FeelingEditRequest FeelingEdit.Request

initialRequest : Request
initialRequest = FeelingListRequest FeelingList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (FeelingListRequest r') -> Task.map FeelingList <| FeelingList.run r'
    (FeelingEditRequest r') -> Task.map FeelingList <| FeelingEdit.run r'

actions : Mailbox Action
actions =
  mailbox NoOp

-- Component utility

delegateTo : (action -> model -> (model, Maybe request))
          -> (model -> Model)
          -> (Maybe request -> Maybe Request)
          -> action
          -> model
          -> (Model, Maybe Request)
delegateTo update' convertModel convertRequest a m =
  let
    (model', request') = update' a m
  in
    (convertModel model', convertRequest request')

justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)
