module Chronicle.Components.FeelingEdit where

import Debug exposing (log)

import Chronicle.Data.Feeling exposing (Feeling, How)
import Chronicle.Data.Feeling as Feeling

type alias Model =
  { editType : EditType
  , formValue : Feeling
  }

type EditType
    = AddNew
    | EditExisting

initialModel : Model
initialModel = { editType=AddNew, formValue=Feeling.default }

-- Actions

type Action
  = UpdateHow How
  | UpdateWhat String
  | UpdateTrigger String
  | UpdateNotes String
  | Save

-- Update

update : Action -> Model -> Model
update action model =
  let
    _ = log "[FeelingEdit:action] " action
    formValue = model.formValue
  in
    case action of
      Save ->
        -- TODO: actually save it to database!
        initialModel
      UpdateWhat what ->
        let
          newValue = { formValue | what <- what }
        in
          { model | formValue <- newValue }
      UpdateTrigger trigger ->
        let
          newValue = { formValue | trigger <- trigger }
        in
          { model | formValue <- newValue }
