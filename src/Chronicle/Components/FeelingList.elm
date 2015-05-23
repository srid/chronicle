module Chronicle.Components.FeelingList where

import Json.Decode  as J
import Task
import Http
import Date

import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, decodeFeeling)

type alias Model =
  { feelings : List Feeling
  }

-- Actions

type Action
  = Initialize (List Feeling)
  | Add Feeling
  | ReloadAll

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

initialModel : Model
initialModel = { feelings=[]} -- editing=FeelingEdit.initialModel }

-- Request

type Request =
  Reload

initialRequest : Request
initialRequest = Reload

run : Request -> Task.Task Http.Error Action
run r =
  case r of
    Reload ->
      Task.map Initialize Database.select
