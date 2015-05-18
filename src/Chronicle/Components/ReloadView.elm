module Chronicle.Components.ReloadView where

import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Controller as Controller
import Chronicle.Components.Reload as Reload

view : Address Controller.Action -> Html
view address =
  let
    msg = Reload.Reload |> Controller.Reload
  in
    button [ class "btn btn-default"
           , HE.onClick address msg ] [ text "Reload" ]
