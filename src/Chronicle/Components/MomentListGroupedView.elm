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
import Chronicle.Components.MomentEditView as MomentEditView
import Chronicle.Components.Search as Search


view : Address Controller.Action -> Model -> Html
view address {moments, editing} =
  let
    momentGroups = groupMomentsByDay moments
    editView      = MomentEditView.view address editing
    displayView   = div [] <| List.map (viewMomentGroup address) momentGroups
  in
    div [] [ editView
           , displayView
           ]


viewMomentGroup : Address Controller.Action -> MomentGroup -> Html
viewMomentGroup address (day, moments) =
  let
    -- FIXME: dayHow and badge must be calculated against unfiltered list
    --        of moments on this day.
    dayHow  = howAggregate moments |> bootstrapContextForHow
    badge   = List.length moments |> toString
    header  = div []
              [ text day
              , span [ class "badge" ] [ text badge ]
              ]
    content = ul [ class "list-group" ]
              (List.map (viewMoment address) moments)
  in
    B.panel' dayHow header content

viewMoment :  Address Controller.Action -> Moment -> Html
viewMoment address moment =
  let
    msgLink
      = MomentEdit.EditThis moment
      |> MomentList.MomentEdit
      |> Controller.MomentList
  in
    li [ class "list-group-item list-group-item-" ]
       [ a [ HE.onClick address msgLink ] [ text "e" ]
       , text " "
       , viewMomentAt moment.at
       , text " "
       , viewMomentHowOrWhat moment.how moment.what
       , viewMomentTrigger moment.trigger
       , Markdown.toHtml moment.notes
       ]

-- TODO: Write a general date formatter elm package.
viewMomentAt : Date.Date -> Html
viewMomentAt at =
  let
    dateIntToString = toString >> String.pad 2 '0'
  in
    code [ (title (Date.dayOfWeek at |> toString)) ]
    [ text <| dateIntToString <| Date.hour at
    , text ":"
    , text <| dateIntToString <| Date.minute at
    ]

viewMomentHowOrWhat : How -> String -> Html
viewMomentHowOrWhat how what =
  let
    howString    = toLower <| toString how
    content      = if what == "" then howString else what
  in
    B.label (bootstrapContextForHow how) content

viewMomentTrigger : String -> Html
viewMomentTrigger trigger =
  if | trigger == "" -> text ""
     | otherwise     -> span [] [ text " ( <- "
                                , strong [] [ text trigger ]
                                , text " ) " ]

bootstrapContextForHow : How -> Maybe B.Context
bootstrapContextForHow how =
  case how of
    Great -> Just B.Success
    Good  -> Just B.Info
    Meh   -> Nothing
    Bad   -> Just B.Warning
    Terrible -> Just B.Danger
