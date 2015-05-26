module Chronicle.Components.MomentView where

import String exposing (toLower)
import Signal exposing (Address)
import Date
import List
import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Model as Model
import Chronicle.Data.Moment exposing (Moment, How(..))
import Chronicle.Controller as Controller
import Chronicle.Components.MomentEditView as MomentEditView


view : Address Controller.Action
    -> (Moment -> Controller.Action)
    -> Moment
    -> Html
view address toAction moment =
  li [ class "list-group-item list-group-item-" ]
     [ viewEditButton address toAction moment
     , text " "
     , viewMomentAt moment.at
     , text " "
     , viewMomentHowOrWhat moment.how moment.what
     , viewMomentTrigger moment.trigger
     , Markdown.toHtml moment.notes
     ]

viewEditButton : Address Controller.Action
              -> (Moment -> Controller.Action)
              -> Moment
              -> Html
viewEditButton address toAction moment =
  button [ class "btn btn-default btn-xs"
         , HE.onClick address (toAction moment) ]
         [ text "e" ]

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
