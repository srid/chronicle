module Chronicle.Components.MomentEdit where

import Date
import Task
import Task exposing (Task, andThen)
import Debug exposing (log)
import Result exposing (toMaybe)

import Date
import Http
import Focus
import Focus exposing (Focus, (=>))

import Chronicle.Database as Database
import Chronicle.Data.Moment exposing (Moment, How, parseHow)
import Chronicle.Data.Moment as Moment

type alias InnerModel =
  { formValue : Moment
  , error : String  -- Not used
  }

type Model
    = Adding InnerModel
    | Modifying (Maybe InnerModel)

setField : Model -> Focus InnerModel field -> field -> Model
setField model focus field =
  let
    set m = Focus.set focus field m
  in
    case model of
      (Adding im)           -> Adding <| set im
      (Modifying (Just im)) -> Modifying <| Just <| set im

initialModel : Model
initialModel = Adding { formValue=Moment.default, error="" }

-- Actions

type Action
  = UpdateHow String
  | UpdateWhat String
  | UpdateTrigger String
  | UpdateNotes String
  | Save
  | EditThis Moment

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    Save ->
      case model of
        (Adding im)     ->
          (initialModel, Just <| PostgrestInsert im.formValue)
        (Modifying (Just im))  ->
          (Modifying Nothing, Just <| PostgrestUpdate im.formValue im.formValue.id)
    EditThis moment ->
      justModel <| Modifying <| Just { formValue=moment, error="" }
    UpdateHow howString ->
      case parseHow howString |> toMaybe of
        Just h   -> justModel <| setField model (formValue => how) h
    UpdateWhat w ->
      justModel <| setField model (formValue => what) w
    UpdateTrigger t ->
      justModel <| setField model (formValue => trigger) t
    UpdateNotes t ->
      justModel <| setField model (formValue => notes) t

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
  = PostgrestInsert Moment
  | PostgrestUpdate Moment Int

-- Tasks

run : Request -> Task Http.Error String
run r =
  case r of
    PostgrestInsert moment ->
      Database.insert moment
    PostgrestUpdate moment id ->
      Database.update moment id
