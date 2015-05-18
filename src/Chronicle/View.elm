module Chronicle.View where

import Signal exposing (Address)
import Html exposing (..)

import Util.Bootstrap as B
import Chronicle.Model as Model
import Chronicle.Controller as Controller
import Chronicle.Components.SearchView as SearchView
import Chronicle.Components.ReloadView as ReloadView
import Chronicle.Components.FeelingListGroupedView as FeelingListGroupedView
import Chronicle.Components.FeelingEditView as FeelingEditView


view : Address Controller.Action -> Model.Model -> Html
view address model =
  let
    model' = Model.transformModel model
  in
    B.fluidContainer
    [ B.pageHeader "Chronicle : Feelings"
    , viewInput address model'
    , FeelingListGroupedView.view address model'.feelings
    ]


viewInput : Address Controller.Action -> Model.Model -> Html
viewInput address model =
  let
    header  = text "Manage"
    content = div []
                [ SearchView.view      address
                , ReloadView.view      address
                , FeelingEditView.view address model.feelingEdit
                ]
  in
    B.panel' (Just B.Primary) header content
