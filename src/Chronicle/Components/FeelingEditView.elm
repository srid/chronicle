module Chronicle.Components.FeelingEditView where

import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingEdit as FeelingEdit

view : Address Controller.Action -> FeelingEdit.Model -> Html
view address {editType, formValue} =
  let
    msgButton = FeelingEdit.Save |> Controller.FeelingEdit
  in
    div [ ]
    [ input' address FeelingEdit.UpdateWhat formValue.what "What am I feeling?"
    , input' address FeelingEdit.UpdateTrigger formValue.trigger "What triggered it?"
    , button [ HE.onClick address msgButton ] [ text "Save" ]
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
    input [ placeholder placeHolder
          , value currentValue
          , HE.on "input" HE.targetValue msg] []
