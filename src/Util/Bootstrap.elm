-- Elm wrapper over http://getbootstrap.com/components/
-- Adding elements per demand of this project.
-- Should make this a package one day.
module Util.Bootstrap where

import String

import Html as H
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

classFor : Maybe Context -> String -> Attribute
classFor ctx prefix =
  classList [ (prefix, True)
            , (prefix ++ contextClassSuffix ctx, True)
            ]

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

pageHeader : List String -> String -> Html
pageHeader extraClasses title =
  let
    classes = "page-header" :: extraClasses
  in
    div [ withClasses classes ]
        [ h1 [] [ text title ]
        ]

fluidContainer : List Html -> Html
fluidContainer children =
  div [ class "container-fluid" ] children

button : Maybe Context -> String -> List Attribute -> Html
button ctx label attributes =
  H.button (classFor ctx "btn" :: attributes)
           [ text label ]


-- Utility

withClasses : List String -> Attribute
withClasses =
  classList << List.map (\c -> (c, True))
