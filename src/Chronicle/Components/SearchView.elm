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
  input [ placeholder "Search text"
        , HE.on "input" HE.targetValue (message address << Controller.Search << Search.Search)
        ] []
