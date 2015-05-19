module Chronicle.Components.FeelingEdit where

import Task
import Task exposing (Task)
import Debug exposing (log)

import Http
import Focus
import Focus exposing ((=>))

import Util.Http exposing (postDiscardBody)

import Chronicle.Database as Database
import Chronicle.Data.Feeling exposing (Feeling, How)
import Chronicle.Data.Feeling as Feeling
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.Reload as Reload

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

update : Action -> Model -> (Model, Maybe Request)
update action model =
  let
    _ = log "[FeelingEdit:action] " action
  in
    case action of
      Save ->
        -- TODO: actually save it to database!
        (initialModel, Just <| PostgrestInsert model.formValue)
      UpdateHow h ->
        justModel <| Focus.set (formValue => how) h model
      UpdateWhat w ->
        justModel <| Focus.set (formValue => what) w model
      UpdateTrigger t ->
        justModel <| Focus.set (formValue => trigger) t model

formValue = Focus.create .formValue (\f r -> { r | formValue <- f r.formValue })
how       = Focus.create .how       (\f r -> { r | how       <- f r.how })
what      = Focus.create .what      (\f r -> { r | what      <- f r.what })
trigger   = Focus.create .trigger   (\f r -> { r | trigger   <- f r.trigger })

justModel : Model -> (Model, Maybe Request)
justModel model =
  (model, Nothing)

-- Request

type Request
  = PostgrestInsert Feeling

run : Request -> Task Http.Error Reload.Action
run r =
  case r of
    PostgrestInsert feeling ->
      let insert feeling =
        feeling
        |> Feeling.encode
        |> Http.string
        |> postDiscardBody Database.tableUrl
      in
        -- Reload everything after adding the feeling. In the ideal world, we
        -- only add the added record, but for now let's just reload
        -- "just in case".
        Task.map (always Reload.Reload) <| insert feeling
