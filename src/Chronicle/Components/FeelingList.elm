module Chronicle.Components.FeelingList where

import Json.Decode  as J
import Task
import Http

import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, decodeFeeling)

type alias Model = List Feeling

-- Actions

type Action
  = Initialize Model

-- Update

update : Action -> Model -> Model
update action model =
  case action of
    Initialize feelings ->
      feelings

initialModel : Model
initialModel = []

-- Request

type Request =
  Reload

initialRequest : Request
initialRequest = Reload

run : Request -> Task.Task Http.Error Action
run r =
  case r of
    Reload ->
      Task.map Initialize <| Http.get decodeModel Database.allUrl

-- JSON decoders

decodeModel : J.Decoder Model
decodeModel = J.list decodeFeeling
