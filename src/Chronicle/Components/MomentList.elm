module Chronicle.Components.FeelingList where

import Json.Decode  as J
import Task
import Task exposing (andThen)
import Http
import Date

import Util.Component exposing (delegateTo)
import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, decodeFeeling)
import Chronicle.Components.FeelingEdit as FeelingEdit

type alias Model =
  { feelings : List Feeling
  , editing  : FeelingEdit.Model
  }

-- Actions

type Action
  = Initialize (List Feeling)
  | Add Feeling
  | ReloadAll
  | FeelingEdit FeelingEdit.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    Initialize feelings ->
      ({ initialModel | feelings <- feelings }, Nothing)
    Add feeling ->
      ({ model | feelings <- feeling :: model.feelings }, Nothing)
    ReloadAll ->
      (model, Just Reload)
    FeelingEdit a ->
      delegateTo
        FeelingEdit.update
        (\m -> { model | editing <- m })
        (Maybe.map FeelingEditRequest)
        a
        model.editing


initialModel : Model
initialModel = { feelings=[], editing=FeelingEdit.initialModel }

-- Request

type Request
  = Reload
  | FeelingEditRequest FeelingEdit.Request

initialRequest : Request
initialRequest = Reload

run : Request -> Task.Task Http.Error Action
run r =
  case r of
    Reload ->
      Task.map Initialize Database.select
    (FeelingEditRequest r') ->
      FeelingEdit.run r' `andThen`
        (always <| run Reload)
