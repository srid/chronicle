module Chronicle.Components.FeelingEditView where

import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingEdit as FeelingEdit

view : Address Controller.Action -> Html
view address =
  let
    -- TODO: how to pass value of "what" input above, to the address here?
    msg = "TODO" |> FeelingEdit.UpdateFields |> Controller.FeelingEdit
  in
    div [ ]
    [ input [ name "what", placeholder "What am I feeling?" ] []
    , button [ HE.onClick address msg ] [ text "TODO" ]
    ]
