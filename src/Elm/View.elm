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
    B.fluidContainer
    [ B.pageHeader "Chronicle : Feelings"
    , viewInput address
    , div [] (List.map viewFeelingGroup feelingGroups)
    ]


viewInput : Address Controller.Action -> Html
viewInput address =
  let
    header  = text "Manage"
    content = div []
                [ viewSearchInput address
                , viewAddFeelingForm address
                ]
  in
    B.panel' (Just B.Primary) header content

viewSearchInput : Address Controller.Action -> Html
viewSearchInput address =
  input [ placeholder "Search text"
        , HE.on "input" HE.targetValue (message address << Controller.Search)
        ] []


viewAddFeelingForm : Address Controller.Action -> Html
viewAddFeelingForm address =
  div [ ]
  [ input [ name "what", placeholder "What am I feeling?" ] []
  -- TODO: how to pass value of "what" input above, to the address here?
  , button [ HE.onClick address <| Controller.Add "TODO" ] [ text "TODO" ]
  ]


viewFeelingGroup : Model.DayFeelings -> Html
viewFeelingGroup (day, feelings) =
  let
    -- FIXME: dayHow and badge must be calculated against unfiltered list
    --        of feelings on this day.
    dayHow  = Model.howAggregate feelings |> bootstrapContextForHow
    badge   = List.length feelings |> toString
    header  = div []
              [ text day
              , span [ class "badge" ] [ text badge ]
              ]
    content = ul [ class "list-group" ]
              (List.map viewFeeling feelings)
  in
    B.panel' dayHow header content

viewFeeling :  Model.Feeling -> Html
viewFeeling feeling =
  li [ class "list-group-item list-group-item-" ]
     [ viewFeelingAt feeling.at
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

viewFeelingHowOrWhat : Model.How -> String -> Html
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

bootstrapContextForHow : Model.How -> Maybe B.Context
bootstrapContextForHow how =
  case how of
    Model.Great -> Just B.Success
    Model.Good  -> Just B.Info
    Model.Meh   -> Nothing
    Model.Bad   -> Just B.Warning
    Model.Terrible -> Just B.Danger
