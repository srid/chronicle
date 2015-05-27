module Chronicle.UI.EditorView where

import Result exposing (toMaybe)
import Maybe exposing (withDefault)
import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B

-- XXX: can we get away with not depending on the Controller module, so that
-- Editor UI component can be made a lbrary?
import Chronicle.Controller as Controller
import Chronicle.UI.Editor as Editor

view : Address Controller.Action
    -> (Editor.Action model -> Controller.Action)
    -> Editor.Model model
    -> Html
view address toAction editor =
  case editor of
    (Editor.Editor fields (Just value)) ->
      let
        values      = List.map (Editor.getField editor) fields
        fieldsView  = List.map2 (viewField address toAction) fields values
        buttonsView = viewButtons address toAction editor
      in
        div [ class "form-group" ] (fieldsView ++ [buttonsView])

viewField : Address Controller.Action
         -> (Editor.Action model -> Controller.Action)
         -> Editor.Field model
         -> String
         -> Html
viewField address toAction field value =
  let
    toAction' = (Editor.UpdateField field) >> toAction
  in
    case field.inputType of
      (Editor.StringInput placeHolder) ->
        input' input address toAction' value placeHolder
      (Editor.TextInput placeHolder) ->
        input' textarea address toAction' value placeHolder
      (Editor.SelectInput placeHolder options) ->
        select' address toAction' options value placeHolder


viewButtons : Address Controller.Action
          -> (Editor.Action model -> Controller.Action)
          -> Editor.Model model
          -> Html
viewButtons address toAction (Editor.Editor _ (Just value)) =
  case value of
    (Editor.Creating _) ->
      B.button (Just B.Primary)
               "Add"
              [ HE.onClick address (toAction Editor.Save) ]
    (Editor.Updating _) ->
      B.buttonGroup "group"
        [ B.button (Just B.Primary)
                   "Save"
                   [ HE.onClick address (toAction Editor.Save) ]
        , B.button Nothing
                   "Cancel"
                   [ HE.onClick address (toAction Editor.Cancel) ]
        ]


-- Form abstraction

input' : (List Attribute -> List Html -> Html)
      -> Address Controller.Action
      -> (String -> Controller.Action)
      -> String
      -> String
      -> Html
input' control address toAction currentValue placeHolder =
  control [ class "form-control"
         , placeholder placeHolder
         , value currentValue
         , HE.on "change" HE.targetValue (toAction >> message address)] []

select' : Address Controller.Action
       -> (String -> Controller.Action)
       -> List String
       -> String
       -> String
       -> Html
select' address toAction options currentValue placeHolder =
  let
    option' val = option [ value val
                         , selected (val == currentValue) ]
                         [ text val ]
  in
    select [ class "form-control"
           , HE.on "change" HE.targetValue (toAction >> message address) ]
      <| List.map option' options
