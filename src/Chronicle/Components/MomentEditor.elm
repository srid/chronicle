module Chronicle.Components.MomentEditor where

import Date
import Task
import Task exposing (Task)
import Debug exposing (log)

import Date
import Http
import Focus
import Focus exposing (Focus, (=>))

import Chronicle.Database as Database
import Chronicle.Data.Moment exposing (Moment, How, parseHow, howValues)
import Chronicle.Data.Moment as Moment
import Chronicle.UI.Editor as Editor

type alias Model =
  Editor.Model Moment

initialModel : (Moment -> Editor.Value Moment) -> Model
initialModel editType =
  let
    value      = editType Moment.default
    howOptions = List.map toString howValues
    howField   = {name="how",     focus=how',     inputType=Editor.SelectInput "How am I feeling?" howOptions}
    fields     =
      [ howField
      , {name="what",    focus=what,    inputType=Editor.StringInput "What is the feeling?"}
      , {name="trigger", focus=trigger, inputType=Editor.StringInput "What triggered the feeling?"}
      , {name="notes",   focus=notes,   inputType=Editor.TextInput "What triggered the feeling?"}
      ]
  in
    Editor.Editor Moment.default fields (Just value)

-- Foci

setHow' : Moment -> String -> Moment
setHow' moment string =
  case parseHow string of
    Ok h -> { moment | how <- h }

getHow' : Moment -> String
getHow' =
  .how >> toString

how'      = Focus.create getHow'    (\f r -> setHow' r <| f <| getHow' r)
what      = Focus.create .what      (\f r -> { r | what      <- f r.what })
trigger   = Focus.create .trigger   (\f r -> { r | trigger   <- f r.trigger })
notes     = Focus.create .notes     (\f r -> { r | notes     <- f r.notes })


-- Actions

type alias Action
  = Editor.Action Moment

-- Update

update : Action -> Model -> (Model, Maybe Request)
update =
  Editor.update

-- Request

type alias Request
  = Editor.Request Moment

-- Tasks

run : Request -> Task Http.Error String
run r =
  case r of
    Editor.Create moment ->
      Database.insert moment
    Editor.Update moment ->
      Database.update moment moment.id
