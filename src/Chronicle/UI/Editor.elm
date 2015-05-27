-- Editor model and UI abstraction using the Focus library.

module Chronicle.UI.Editor where

import Focus exposing (Focus, (=>))

type Model model
  = Editor (Fields model) (Maybe (Value model))

type Value model
  = Creating model
  | Updating model

-- How to map to UI elements? Esp. String -> Select
type alias Field model =
  { name:      String
  , focus:     Focus model String
  , inputType: InputType
  }

type InputType
  = StringInput String
  | TextInput String
  | SelectInput String (List String)

type alias Fields model =
  List (Field model)

mapModel : (model -> model) -> Model model -> Model model
mapModel f (Editor fields value) =
  case value of
    Just (Creating m) -> Editor fields <| Just <| Creating <| (f m)
    Just (Updating m) -> Editor fields <| Just <| Updating <| (f m)

getModel : Model model -> model
getModel (Editor fields value) =
  case value of
    Just (Creating m) -> m
    Just (Updating m) -> m

reset : Model model -> Model model
reset (Editor fields value) =
  Editor fields Nothing

active : Model model -> Bool
active (Editor _ value) =
  not <| value == Nothing

setField : Model model -> Field model -> String -> Model model
setField m {name, focus} value =
  mapModel (Focus.set focus value) m

getField : Model model -> Field model -> String
getField m {focus} =
  Focus.get focus <| getModel m

type Action model
  = UpdateField (Field model) String
  | Save
  | Cancel
  | EditThis model

type Request model
  = Create model
  | Update model

requestFor : Model model -> Request model
requestFor (Editor _ value) =
  case value of
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
      case m of
        (Editor fields _) ->
          (Editor fields <| Just <| Updating m', Nothing)
    UpdateField field value ->
      (setField m field value, Nothing)
