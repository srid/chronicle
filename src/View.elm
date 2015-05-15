module View where

import String exposing (toLower)
import Signal exposing (Address)
import Markdown

import Model
import Controller
import Html exposing (..)
import Html.Attributes exposing (..)


viewFeelingGroup : Model.DayFeelings -> Html
viewFeelingGroup (day, feelings) =
  div []
  [ h2 [] [text day],
    ul [] (List.map viewFeeling feelings) ]


viewFeeling : Model.Feeling -> Html
viewFeeling feeling =
  li []
     [
       strong [] [ text feeling.day ],
       text " | ",
       span [] [ viewFeelingHowOrWhat feeling.how feeling.what ],
       viewFeelingTrigger feeling.trigger,
       Markdown.toHtml feeling.notes
     ]

viewFeelingHowOrWhat : String -> String -> Html
viewFeelingHowOrWhat how what =
  let
    elementStyle = style [ ("color", colorForHow how ) ]
    content      = if what == "" then how else what
  in
    span [ elementStyle ] [text content]

viewFeelingTrigger : String -> Html
viewFeelingTrigger trigger =
  if | trigger == "" -> text ""
     | otherwise     -> span [] [ text " ( <- "
                                , strong [] [ text trigger ]
                                , text " ) " ]

colorForHow : String -> String
colorForHow how =
  case toLower how of
    "great" -> "green"
    "good"  -> "blue"
    "meh"   -> "grey"
    "bad"   -> "orange"
    "terrible" -> "red"


view : Address Controller.Action -> Model.Model -> Html
view address feelings =
  let
    feelingGroups = Model.groupFeelings feelings
  in
    div []
    [ h1 [] [ text "Feelings" ],
      div [] (List.map viewFeelingGroup feelingGroups) ]
