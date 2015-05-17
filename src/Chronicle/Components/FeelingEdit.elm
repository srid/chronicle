module Chronicle.Components.FeelingEdit where

import Debug exposing (log)

import Chronicle.Data.Feeling exposing (Feeling)

type alias Model =
  { editType : EditType
  , formValues : Maybe Feeling
  }

type EditType
    = AddNew
    | EditExisting

initialModel : Model
initialModel = { editType=AddNew, formValues=Nothing }

-- Actions

type Action
  = UpdateFields String

-- Update

update : Action -> Model -> Model
update action model =
  case action of
    UpdateFields whatever ->
      let
        _ = log "[FeelingEdit] Updating fields with " whatever
      in
        model
