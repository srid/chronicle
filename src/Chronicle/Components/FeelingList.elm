module Chronicle.Components.FeelingList where

import Json.Decode  as J
import Task
import Http
import Date

import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, decodeFeeling)

type alias Model =
  { feelings : List Feeling
  , editing  : Maybe EditTarget
  }

type EditTarget
  = AddingNew
  | EditingThis Date.Date

-- Actions

type Action
  = Initialize (List Feeling)
  | Add Feeling

-- Update

update : Action -> Model -> Model
update action model =
  case action of
    Initialize feelings ->
      { initialModel | feelings <- feelings }
    Add feeling ->
      { model | feelings <- feeling :: model.feelings }

initialModel : Model
initialModel = { feelings=[], editing=Nothing }

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
