module Chronicle.Components.FeelingEdit where

import Debug exposing (log)

import Focus
import Focus exposing ((=>))

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
  in
    case action of
      Save ->
        -- TODO: actually save it to database!
        initialModel
      UpdateWhat w ->
        Focus.set (formValue => what) w model
      UpdateTrigger t ->
        Focus.set (formValue => trigger) t model

formValue = Focus.create .formValue (\f r -> { r | formValue <- f r.formValue })
what      = Focus.create .what      (\f r -> { r | what      <- f r.what })
trigger   = Focus.create .trigger   (\f r -> { r | trigger   <- f r.trigger })
