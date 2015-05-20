module Chronicle.Components.FeelingEdit where

import Task
import Task exposing (Task, andThen)
import Debug exposing (log)
import Result exposing (toMaybe)

import Http
import Focus
import Focus exposing ((=>))

import Util.Http exposing (postDiscardBody)

import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, How, parseHow)
import Chronicle.Data.Feeling as Feeling
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.Reload as Reload

type alias Model =
  { editType : EditType
  , formValue : Feeling
  , error : String  -- Idealy this should be a Map from field to error
  }

type EditType
    = AddNew
    | EditExisting

initialModel : Model
initialModel = { editType=AddNew, formValue=Feeling.default, error="" }

-- Actions

type Action
  = UpdateHow String
  | UpdateWhat String
  | UpdateTrigger String
  | UpdateNotes String
  | Save

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  let
    _ = log "[FeelingEdit:action] " action
  in
    case action of
      Save ->
        (initialModel, Just <| PostgrestInsert model.formValue)
      UpdateHow howString ->
        case parseHow howString |> toMaybe of
          Nothing  -> justModel <| { model | error <- "Invalid value for how" }
          Just h   -> justModel <| Focus.set (formValue => how) h model
      UpdateWhat w ->
        justModel <| Focus.set (formValue => what) w model
      UpdateTrigger t ->
        justModel <| Focus.set (formValue => trigger) t model
      UpdateNotes t ->
        justModel <| Focus.set (formValue => notes) t model

formValue = Focus.create .formValue (\f r -> { r | formValue <- f r.formValue })
how       = Focus.create .how       (\f r -> { r | how       <- f r.how })
what      = Focus.create .what      (\f r -> { r | what      <- f r.what })
trigger   = Focus.create .trigger   (\f r -> { r | trigger   <- f r.trigger })
notes     = Focus.create .notes     (\f r -> { r | notes     <- f r.notes })

justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)

-- Request

type Request
  = PostgrestInsert Feeling

run : Request -> Task Http.Error FeelingList.Action
run r =
  case r of
    PostgrestInsert feeling ->
      let
        insert feeling =
          feeling
          |> Feeling.encode
          |> Http.string
          |> postDiscardBody Database.tableUrl
        reloadAll =
          always <| FeelingList.run FeelingList.Reload
      in
        -- Reload everything after adding the feeling. In the ideal world, we
        -- only add the added record, but for now let's just reload
        -- "just in case".
        insert feeling `andThen` reloadAll
