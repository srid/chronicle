module Chronicle.Components.MomentEditView where

import Result exposing (toMaybe)
import Maybe exposing (withDefault)
import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Data.Moment exposing (Moment, parseHow, howValues, How(..))
import Chronicle.Controller as Controller
import Chronicle.Components.MomentEdit as MomentEdit

view : Address Controller.Action
    -> (MomentEdit.Action -> Controller.Action)
    -> MomentEdit.Model
    -> Html
view address toAction editModel =
  let
    formValue    = case editModel of
                    (MomentEdit.Adding im)           -> im.formValue
                    (MomentEdit.Modifying (Just im)) -> im.formValue
    howOptions   = List.map toString howValues
    formElements = [ SelectInput address (toAction << MomentEdit.UpdateHow) howOptions "How am I feeling?" (toString formValue.how)
                   , StringInput address (toAction << MomentEdit.UpdateWhat) "What is the feeling?" formValue.what
                   , StringInput address (toAction << MomentEdit.UpdateTrigger) "What triggered it?" formValue.trigger
                   , MultilineStringInput address (toAction << MomentEdit.UpdateNotes) "Notes" formValue.notes
                   ]
    msgButton = toAction MomentEdit.Save
    buttonLabel = case editModel of
      (MomentEdit.Adding _)    -> "Add"
      (MomentEdit.Modifying _) -> "Save " ++ toString formValue.id
  in
    div [ class "form-group" ]
    ((List.map viewFormInput formElements) ++
     [viewButtons address toAction editModel]
    )


viewButtons : Address Controller.Action
          -> (MomentEdit.Action -> Controller.Action)
          -> MomentEdit.Model
          -> Html
viewButtons address toAction editModel =
  case editModel of
    (MomentEdit.Adding _) ->
      B.button (Just B.Primary)
               "Add"
              [ HE.onClick address (toAction MomentEdit.Save) ]
    (MomentEdit.Modifying (Just im)) ->
      let
        moment = im.formValue
      in
        B.buttonGroup "group"
          [ B.button (Just B.Primary)
                     "Save"
                     [ HE.onClick address (toAction MomentEdit.Save) ]
          , B.button Nothing
                     "Cancel"
                     [ HE.onClick address (toAction MomentEdit.Cancel) ]
          ]


-- Form abstraction

type FormInput
  = StringInput (Address Controller.Action) (String -> Controller.Action) String String
  | MultilineStringInput (Address Controller.Action) (String -> Controller.Action) String String
  | SelectInput (Address Controller.Action) (String -> Controller.Action) (List String) String String

viewFormInput : FormInput -> Html
viewFormInput fi =
  case fi of
    (StringInput address toAction placeHolder value) ->
      input' input address toAction value placeHolder
    (MultilineStringInput address toAction placeHolder value) ->
      input' textarea address toAction value placeHolder
    (SelectInput address toAction options placeHolder value) ->
      select' address toAction options value placeHolder

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
