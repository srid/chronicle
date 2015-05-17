module Chronicle.Components.SearchView where

import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Controller as Controller
import Chronicle.Components.Search as Search

view : Address Controller.Action -> Html
view address =
  let
    msg = Search.SearchFor >> Controller.Search >> message address
  in
    input [ placeholder "Search"
          , HE.on "input" HE.targetValue msg
          ] []
