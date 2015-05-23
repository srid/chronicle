module Chronicle.Components.FeelingListGroupedView where

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
import Chronicle.Data.Feeling exposing (Feeling, How(..))
import Chronicle.Data.FeelingGroup exposing (FeelingGroup, groupFeelingsByDay, howAggregate)
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingList exposing (Model)
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit
import Chronicle.Components.FeelingEditView as FeelingEditView
import Chronicle.Components.Search as Search


view : Address Controller.Action -> Model -> Html
view address {feelings, editing} =
  let
    feelingGroups = groupFeelingsByDay feelings
    editView      = FeelingEditView.view address editing
    displayView   = div [] <| List.map (viewFeelingGroup address) feelingGroups
  in
    div [] [ editView
           , displayView
           ]


viewFeelingGroup : Address Controller.Action -> FeelingGroup -> Html
viewFeelingGroup address (day, feelings) =
  let
    -- FIXME: dayHow and badge must be calculated against unfiltered list
    --        of feelings on this day.
    dayHow  = howAggregate feelings |> bootstrapContextForHow
    badge   = List.length feelings |> toString
    header  = div []
              [ text day
              , span [ class "badge" ] [ text badge ]
              ]
    content = ul [ class "list-group" ]
              (List.map (viewFeeling address) feelings)
  in
    B.panel' dayHow header content

viewFeeling :  Address Controller.Action -> Feeling -> Html
viewFeeling address feeling =
  let
    msgLink
      = FeelingEdit.EditThis feeling
      |> FeelingList.FeelingEdit
      |> Controller.FeelingList
  in
    li [ class "list-group-item list-group-item-" ]
       [ a [ HE.onClick address msgLink ] [ text "e" ]
       , text " "
       , viewFeelingAt feeling.at
       , text " "
       , viewFeelingHowOrWhat feeling.how feeling.what
       , viewFeelingTrigger feeling.trigger
       , Markdown.toHtml feeling.notes
       ]

-- TODO: Write a general date formatter elm package.
viewFeelingAt : Date.Date -> Html
viewFeelingAt at =
  let
    dateIntToString = toString >> String.pad 2 '0'
  in
    code [ (title (Date.dayOfWeek at |> toString)) ]
    [ text <| dateIntToString <| Date.hour at
    , text ":"
    , text <| dateIntToString <| Date.minute at
    ]

viewFeelingHowOrWhat : How -> String -> Html
viewFeelingHowOrWhat how what =
  let
    howString    = toLower <| toString how
    content      = if what == "" then howString else what
  in
    B.label (bootstrapContextForHow how) content

viewFeelingTrigger : String -> Html
viewFeelingTrigger trigger =
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
