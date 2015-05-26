module Chronicle.Components.MomentList where

import Json.Decode  as J
import Task
import Task exposing (andThen)
import Http
import Date

import Util.Component exposing (updateInner)
import Chronicle.Database as Database
import Chronicle.Data.Moment exposing (Moment, decodeMoment)
import Chronicle.Components.MomentEdit as MomentEdit

type alias Model =
  { moments : List Moment
  , editing  : MomentEdit.Model
  }

-- Actions

type Action
  = Initialize (List Moment)
  | Add Moment
  | ReloadAll
  | MomentEdit MomentEdit.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    Initialize moments ->
      ({ initialModel | moments <- moments }, Nothing)
    Add moment ->
      ({ model | moments <- moment :: model.moments }, Nothing)
    ReloadAll ->
      (model, Just Reload)
    MomentEdit a ->
      updateInner
        MomentEdit.update
        MomentEditRequest
        (\m -> { model | editing <- m })
        a
        model.editing


initialModel : Model
initialModel = { moments=[], editing=MomentEdit.initialModel }

-- Request

type Request
  = Reload
  | MomentEditRequest MomentEdit.Request

initialRequest : Request
initialRequest = Reload

run : Request -> Task.Task Http.Error Action
run r =
  case r of
    Reload ->
      Task.map Initialize Database.select
    (MomentEditRequest r') ->
      MomentEdit.run r' `andThen`
        (always <| run Reload)
