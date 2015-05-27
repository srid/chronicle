-- Editor model and UI abstraction using the Focus library.

module Chronicle.UI.Editor where

import Focus exposing (Focus, (=>))

type alias Model model =
  { fields   : List (Field model)
  , value    : Maybe (Value model)
  }

type Value model
  = Creating model
  | Updating model

-- How to map to UI elements? Esp. String -> Select
type alias Field model =
  (String, Focus model String)

mapModel : (model -> model) -> Model model -> Model model
mapModel f editor =
  case editor.value of
    Just (Creating m) -> { editor | value <- Just (Creating (f m)) }
    Just (Updating m) -> { editor | value <- Just (Creating (f m)) }

reset : Model model -> Model model
reset editor =
  { editor | value <- Nothing }

active : Model model -> Bool
active editor =
  not <| editor.value == Nothing

setField : Model model -> Field model -> String -> Model model
setField m (name, focus) value =
  mapModel (Focus.set focus value) m

type Action model
  = UpdateField (Field model) String
  | Save
  | Cancel
  | EditThis model

type Request model
  = Create model
  | Update model

requestFor : Model model -> Request model
requestFor editor =
  case editor.value of
    Just (Creating m) -> Create m
    Just (Updating m) -> Update m

update : Action model -> Model model -> (Model model, Maybe (Request model))
update action m =
  case action of
    Cancel ->
      (reset m, Nothing)
    Save ->
      (reset m, Just <| requestFor m)
    EditThis m' ->
      ({ m | value <- Just (Updating m')}, Nothing)
    UpdateField field value ->
      (setField m field value, Nothing)
