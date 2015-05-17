module Chronicle.View where

import Signal exposing (Address)
import Html exposing (..)

import Util.Bootstrap as B
import Chronicle.Model as Model
import Chronicle.Controller as Controller
import Chronicle.Components.SearchView as SearchView
import Chronicle.Components.FeelingListGroupedView as FeelingListGroupedView
import Chronicle.Components.FeelingEditView as FeelingEditView


view : Address Controller.Action -> Model.Model -> Html
view address model =
  let
    model' = Model.transformModel model
  in
    B.fluidContainer
    [ B.pageHeader "Chronicle : Feelings"
    , viewInput address
    , FeelingListGroupedView.view address model'.feelings
    ]


viewInput : Address Controller.Action -> Html
viewInput address =
  let
    header  = text "Manage"
    content = div []
                [ SearchView.view      address
                , FeelingEditView.view address
                ]
  in
    B.panel' (Just B.Primary) header content
