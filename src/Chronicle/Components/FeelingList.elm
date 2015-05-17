module Chronicle.Components.FeelingList where

import Json.Decode  as J

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

-- JSON decoders

decodeModel : J.Decoder Model
decodeModel = J.list decodeFeeling
