module View where

import Signal exposing (Address)
import Model
import Controller
import Html.Events exposing (onClick)
import Html             exposing (Html, h1, h2, div, span, ul, li, a, em, strong,
                                  button, text)


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
       span [] [ text feeling.how,
                 text ":",
                 text feeling.what ],
       strong [] [ text feeling.trigger ],
       em [] [ text feeling.notes ]
     ]


view : Address Controller.Action -> Model.Model -> Html
view address feelings =
  let
    feelingGroups = Model.groupFeelings feelings
  in
    div []
    [ h1 [] [ text "Feelings" ],
      div [] (List.map viewFeelingGroup feelingGroups) ]
