module Chronicle.Components.MomentListGroupedView where

import String exposing (toLower)
import Signal exposing (Address)
import Date
import List
import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.List as List2
import Util.Bootstrap as B
import Chronicle.Model as Model
import Chronicle.Data.Moment exposing (Moment, How(..))
import Chronicle.Data.MomentGroup exposing (MomentGroup, groupMomentsByDay, howAggregate)
import Chronicle.Controller as Controller
import Chronicle.Components.MomentList exposing (Model)
import Chronicle.Components.MomentList as MomentList
import Chronicle.Components.MomentEdit as MomentEdit
import Chronicle.Components.MomentView as MomentView
import Chronicle.Components.MomentEditView as MomentEditView
import Chronicle.Components.Search as Search


view : Address Controller.Action -> Model -> Html
view address {moments, editing} =
  let
    momentGroups = groupMomentsByDay moments
    toAction      = MomentList.MomentEdit >> Controller.MomentList
    editView      = MomentEditView.view address toAction editing
    displayView   = div [] <| List.map (viewMomentGroup address) momentGroups
  in
    div [] [ displayView
           ]


viewMomentGroup : Address Controller.Action -> MomentGroup -> Html
viewMomentGroup address (day, moments) =
  let
    -- FIXME: dayHow and badge must be calculated against unfiltered list
    --        of moments on this day.
    dayHow  = howAggregate moments |> MomentView.bootstrapContextForHow
    badge   = List.length moments |> toString
    header  = div []
              [ text day
              , span [ class "badge" ] [ text badge ]
              ]
    toAction = MomentEdit.EditThis >> MomentList.MomentEdit >> Controller.MomentList
    content = ul [ class "list-group" ]
              (List.map (MomentView.view address toAction) moments)
  in
    B.panel' dayHow header content
