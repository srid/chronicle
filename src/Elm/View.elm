module View where

import String exposing (toLower)
import Signal exposing (Address, message)
import Date
import Markdown

import Model
import Controller
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE
import Bootstrap as B


view : Address Controller.Action -> Model.Model -> Html
view address model =
  let
    feelingGroups = Model.computeModel model
  in
    div []
    [ h1 [] [ text "Chronicle : Feelings" ]
    , viewSearchInput address
    , div [] (List.map viewFeelingGroup feelingGroups)
    ]

viewSearchInput : Address Controller.Action -> Html
viewSearchInput address =
  input [ placeholder "Search text"
        , HE.on "input" HE.targetValue (message address << Controller.Search)
        ] []

viewFeelingGroup : Model.DayFeelings -> Html
viewFeelingGroup (day, feelings) =
  let
    header  = div []
              [ text day
              , span [ class "badge" ]
                [ text <| toString <| List.length feelings ]
              ]
    content = ul [ class "list-group" ]
              (List.map viewFeeling feelings)
    howMode = bootstrapContextForHow <| Model.howMode feelings
  in
    B.panel' howMode header content

viewFeeling :  Model.Feeling -> Html
viewFeeling feeling =
  li [ class "list-group-item list-group-item-" ]
     [
       viewFeelingAt feeling.at,
       text " | ",
       viewFeelingHowOrWhat feeling.how feeling.what,
       viewFeelingTrigger feeling.trigger,
       Markdown.toHtml feeling.notes
     ]

-- TODO: Write a general date formatter elm package.
viewFeelingAt : Date.Date -> Html
viewFeelingAt at =
  code [] [ text <| toString <| Date.dayOfWeek at
          , text " "
          , text <| toString <| Date.hour at
          , text ":"
          , text <| toString <| Date.minute at
          ]

viewFeelingHowOrWhat : Model.How -> String -> Html
viewFeelingHowOrWhat how what =
  let
    howString    = toLower <| toString how
    elementStyle = style [ ("color", colorForHow how ) ]
    content      = if what == "" then howString else what
  in
    span [ elementStyle ] [text content]

viewFeelingTrigger : String -> Html
viewFeelingTrigger trigger =
  if | trigger == "" -> text ""
     | otherwise     -> span [] [ text " ( <- "
                                , strong [] [ text trigger ]
                                , text " ) " ]

colorForHow : Model.How -> String
colorForHow how =
  case how of
    Model.Great -> "green"
    Model.Good  -> "blue"
    Model.Meh   -> "grey"
    Model.Bad   -> "orange"
    Model.Terrible -> "red"

bootstrapContextForHow : Model.How -> Maybe B.Context
bootstrapContextForHow how =
  case how of
    Model.Great -> Just B.Success
    Model.Good  -> Just B.Info
    Model.Meh   -> Nothing
    Model.Bad   -> Just B.Warning
    Model.Terrible -> Just B.Danger
