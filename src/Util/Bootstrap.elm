-- Elm wrapper over http://getbootstrap.com/components/
-- Adding elements per demand of this project.
-- Should make this a package one day.
module Util.Bootstrap where

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE


type Context
  = Primary
  | Success
  | Info
  | Warning
  | Danger

contextClassSuffix : Maybe Context -> String
contextClassSuffix c' =
  case c' of
    Nothing -> "default"
    Just c  -> String.toLower <| toString c

panel : Html -> Html -> Html
panel = panel' Nothing

panel' : Maybe Context -> Html -> Html -> Html
panel' ctx' title content =
  div [ classList  [("panel", True), ("panel-" ++ contextClassSuffix ctx', True)] ]
  [ div [ class "panel-heading" ] [ title ]
  , div [ class "panel-body" ] [ content ]
  ]

label : Maybe Context -> String -> Html
label ctx string =
  span [ class ("label label-" ++ contextClassSuffix ctx) ]
  [ text string ]

pageHeader : String -> Html
pageHeader title =
  div [ class "page-header" ]
    [ h1 [] [ text title ]
    ]

fluidContainer : List Html -> Html
fluidContainer children =
  div [ class "container-fluid" ] children
