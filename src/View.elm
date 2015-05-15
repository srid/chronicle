module View where

import Signal exposing (Address)
import Model
import Controller
import Html.Events exposing (onClick)
import Html             exposing (Html, h1, div, span, ul, li, a, em, strong,
                                  button, text)


viewFeeling : Model.Feeling -> Html
viewFeeling feeling =
  li []
     [
       strong [] [ text feeling.at ],
       text " ~ ",
       span [] [ text feeling.how,
                 text ":",
                 text feeling.what ],
       strong [] [ text feeling.trigger ],
       em [] [ text feeling.notes ]
     ]


view : Address Controller.Action -> Model.Model -> Html
view address feelings =
  div []
  [ h1 [] [ text "Feelings" ],
    button [ onClick address Controller.Start ] [ text "Start" ],
    ul []
      ( List.map viewFeeling feelings )
  ]
