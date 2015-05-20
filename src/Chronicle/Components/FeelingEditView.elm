module Chronicle.Components.FeelingEditView where

import Result exposing (toMaybe)
import Maybe exposing (withDefault)
import Signal exposing (Address, message)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE

import Util.Bootstrap as B
import Chronicle.Data.Feeling exposing (Feeling, parseHow, howValues, How(..))
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingEdit as FeelingEdit

view : Address Controller.Action -> FeelingEdit.Model -> Html
view address {editType, formValue, error} =
  let
    howOptions   = List.map toString howValues
    formElements = [ SelectInput address FeelingEdit.UpdateHow howOptions "How am I feeling?" (toString formValue.how)
                   , StringInput address FeelingEdit.UpdateWhat "What is the feeling?" formValue.what
                   , StringInput address FeelingEdit.UpdateTrigger "What triggered it?" formValue.trigger
                   , MultilineStringInput address FeelingEdit.UpdateNotes "Notes" formValue.notes
                   ]
    msgButton = FeelingEdit.Save |> Controller.FeelingEdit
    buttonLabel = case editType of
      FeelingEdit.AddNew -> "Add"
      FeelingEdit.EditExisting -> "Save"
  in
    -- TODO: a select element (not input) for "how" field
    -- TODO: a textarea for notes
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
  = StringInput (Address Controller.Action) (String -> FeelingEdit.Action) String String
  | MultilineStringInput (Address Controller.Action) (String -> FeelingEdit.Action) String String
  | SelectInput (Address Controller.Action) (String -> FeelingEdit.Action) (List String) String String

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
      -> (String -> FeelingEdit.Action)
      -> String
      -> String
      -> Html
input' control address action currentValue placeHolder =
  let
    msg = action >> Controller.FeelingEdit >> message address
  in
    control [ class "form-control"
           , placeholder placeHolder
           , value currentValue
           , HE.on "input" HE.targetValue msg] []

select' : Address Controller.Action
       -> (String -> FeelingEdit.Action)
       -> List String
       -> String
       -> String
       -> Html
select' address action options currentValue placeHolder =
  let
    msg = action >> Controller.FeelingEdit >> message address
  in
    select [ HE.on "input" HE.targetValue msg ]
      <| List.map (\v -> option [ value v ] [ text v ]) options
