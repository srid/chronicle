module Chronicle.Components.MomentList where

import Json.Decode  as J
import Task
import Task exposing (andThen)
import Http
import Date

import Util.Component exposing (updateInner)
import Chronicle.Database as Database
import Chronicle.Data.Moment exposing (Moment, decodeMoment)
import Chronicle.Components.MomentEditor as MomentEditor
import Chronicle.UI.Editor as Editor

type alias Model =
  { moments : List Moment
  , editing  : MomentEditor.Model
  }

-- Actions

type Action
  = Initialize (List Moment)
  | Add Moment
  | ReloadAll
  | MomentEditor MomentEditor.Action

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
    MomentEditor a ->
      updateInner
        MomentEditor.update
        MomentEditorRequest
        (\m -> { model | editing <- m })
        a
        model.editing


initialModel : Model
initialModel = { moments=[], editing=(MomentEditor.initialModel Editor.Updating) }

-- Request

type Request
  = Reload
  | MomentEditorRequest MomentEditor.Request

initialRequest : Request
initialRequest = Reload

run : Request -> Task.Task Http.Error Action
run r =
  case r of
    Reload ->
      Task.map Initialize Database.select
    (MomentEditorRequest r') ->
      MomentEditor.run r' `andThen`
        (always <| run Reload)
