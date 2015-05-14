module View where

import Model
import Html             exposing (Html, div, span, ul, li, a, em, strong, text)


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


view : Model.Model -> Html
view feelings =
  ul []
     ( List.map viewFeeling feelings )
