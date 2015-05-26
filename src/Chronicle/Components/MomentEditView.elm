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
import Chronicle.Components.MomentList as MomentList

toOutterAction : MomentEdit.Action -> Controller.Action
toOutterAction action =
  action |> MomentList.MomentEdit |> Controller.MomentList

view : Address Controller.Action -> MomentEdit.Model -> Html
view address {editType, formValue, error} =
  let
    howOptions   = List.map toString howValues
    formElements = [ SelectInput address MomentEdit.UpdateHow howOptions "How am I moment?" (toString formValue.how)
                   , StringInput address MomentEdit.UpdateWhat "What is the moment?" formValue.what
                   , StringInput address MomentEdit.UpdateTrigger "What triggered it?" formValue.trigger
                   , MultilineStringInput address MomentEdit.UpdateNotes "Notes" formValue.notes
                   ]
    msgButton = MomentEdit.Save |> toOutterAction
    buttonLabel = case editType of
      MomentEdit.AddNew -> "Add"
      MomentEdit.EditExisting at -> "Save " ++ toString at
  in
    div [ class "form-group" ]
    ((List.map viewFormInput formElements) ++
     [ viewFormError error
     , button [ class "btn btn-primary"
              , HE.onClick address msgButton ] [ text buttonLabel ]
     ]
    )

viewFormError : String -> Html
viewFormError error =
  div [ style [("color",  "red")] ] [ text error ]

-- Form abstraction

type FormInput
  = StringInput (Address Controller.Action) (String -> MomentEdit.Action) String String
  | MultilineStringInput (Address Controller.Action) (String -> MomentEdit.Action) String String
  | SelectInput (Address Controller.Action) (String -> MomentEdit.Action) (List String) String String

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
      -> (String -> MomentEdit.Action)
      -> String
      -> String
      -> Html
input' control address action currentValue placeHolder =
  let
    msg = action >> toOutterAction >> message address
  in
    control [ class "form-control"
           , placeholder placeHolder
           , value currentValue
           , HE.on "change" HE.targetValue msg] []

select' : Address Controller.Action
       -> (String -> MomentEdit.Action)
       -> List String
       -> String
       -> String
       -> Html
select' address action options currentValue placeHolder =
  let
    msg         = action >> toOutterAction >> message address
    option' val = option [ value val
                         , selected (val == currentValue) ]
                         [ text val ]
  in
    select [ class "form-control"
           , HE.on "change" HE.targetValue msg ]
      <| List.map option' options
