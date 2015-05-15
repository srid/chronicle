module View where

import String exposing (toLower)
import Signal exposing (Address)

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
       text " ~ ",
       span [] [ viewFeelingHow feeling.how,
                 text ":",
                 text feeling.what ],
       strong [] [ text feeling.trigger ],
       em [] [ text feeling.notes ]
     ]

viewFeelingHow : String -> Html
viewFeelingHow how =
  let
    elementStyle = style [ ("color", colorForHow how ) ]
  in
    span [ elementStyle ] [text how]

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
