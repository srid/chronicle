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
import Chronicle.Components.MomentEditor as MomentEditor
import Chronicle.Components.MomentView as MomentView
import Chronicle.Components.Search as Search
import Chronicle.UI.Editor as Editor
import Chronicle.UI.EditorView as EditorView


editFieldAction : Editor.Action Moment -> Controller.Action
editFieldAction = MomentList.MomentEditor >> Controller.MomentList

editTriggerAction : Moment -> Controller.Action
editTriggerAction = Editor.EditThis >> MomentList.MomentEditor >> Controller.MomentList

view : Address Controller.Action -> Model -> Html
view address {moments, editing} =
  let
    momentGroups = groupMomentsByDay moments
    toAction      = MomentList.MomentEditor >> Controller.MomentList
    -- editView      = MomentEditorView.view address toAction editing
    displayView   = div [] <| List.map (viewMomentGroup address editing) momentGroups
  in
    div [] [ displayView
           ]


viewMomentGroup : Address Controller.Action -> MomentEditor.Model -> MomentGroup -> Html
viewMomentGroup address editing (day, moments) =
  let
    -- FIXME: dayHow and badge must be calculated against unfiltered list
    --        of moments on this day.
    dayHow  = howAggregate moments |> MomentView.bootstrapContextForHow
    badge   = List.length moments |> toString
    header  = div []
              [ text day
              , span [ class "badge" ] [ text badge ]
              ]
    viewMoment moment =
      case editingThis editing moment of
        -- Display a form to edit this moment
        True  -> EditorView.view address editFieldAction editing
        -- Just display the moment
        False -> MomentView.view address editTriggerAction moment
    content = ul [ class "list-group" ]
              (List.map viewMoment moments)
  in
    B.panel' dayHow header content

-- XXX: Don't presume the internal structure of editor here.
editingThis : MomentEditor.Model -> Moment -> Bool
editingThis (Editor.Editor _ _ value) moment =
  case value of
    (Just (Editor.Updating model)) ->
      model.id == moment.id
    otherwise
      -> False
