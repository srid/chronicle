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
    -- TODO: how to pass value of "what" input above, to the address here?
    msgButton = FeelingEdit.Save |> Controller.FeelingEdit
    msgWhat = FeelingEdit.UpdateWhat >> Controller.FeelingEdit >> message address
  in
    div [ ]
    [ input [ name "what"
            , placeholder "What am I feeling?"
            , value formValue.what
            , HE.on "input" HE.targetValue msgWhat] []
    , button [ HE.onClick address msgButton ] [ text "Save" ]
    ]
