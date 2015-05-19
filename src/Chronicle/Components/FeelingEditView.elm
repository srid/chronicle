module Chronicle.Components.FeelingEditView where

import Result exposing (toMaybe)
import Maybe exposing (withDefault)
import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Data.Feeling exposing (parseHow, How(..))
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingEdit as FeelingEdit

view : Address Controller.Action -> FeelingEdit.Model -> Html
view address {editType, formValue} =
  let
    msgButton = FeelingEdit.Save |> Controller.FeelingEdit
    buttonLabel = case editType of
      FeelingEdit.AddNew -> "Add"
      FeelingEdit.EditExisting -> "Save"
  in
    -- TODO: a select element (not input) for "how" field
    -- TODO: a textarea for notes
    div [ class "form-group" ]
    [ input' address (FeelingEdit.UpdateHow << (parseHowWithDefault Meh)) (toString formValue.how) "How am I feeling?"
    , input' address FeelingEdit.UpdateWhat formValue.what "What am I feeling?"
    , input' address FeelingEdit.UpdateTrigger formValue.trigger "What triggered it?"
    , button [ class "btn btn-primary"
             , HE.onClick address msgButton ] [ text buttonLabel ]
    ]

-- input' is an input element for filling in a feeling edit form
input' : Address Controller.Action
      -> (String -> FeelingEdit.Action)
      -> String
      -> String
      -> Html
input' address action currentValue placeHolder =
  let
    msg = action >> Controller.FeelingEdit >> message address
  in
    input [ class "form-control"
          , placeholder placeHolder
          , value currentValue
          , HE.on "input" HE.targetValue msg] []

parseHowWithDefault : How -> String -> How
parseHowWithDefault default string =
  parseHow string
  |> toMaybe
  |> withDefault default
