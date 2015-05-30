-- Editor model and UI abstraction using the Focus library.

module Chronicle.UI.Editor where

import Maybe

import Focus exposing (Focus, (=>))

type Model model
  = Editor model (Fields model) (Maybe (Value model))

type Value model
  = Creating model
  | Updating model

type alias Fields model =
  List (Field model)

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

mapModel : (model -> model) -> Model model -> Model model
mapModel f (Editor empty fields value) =
  case value of
    Just (Creating m) -> Editor empty fields <| Just <| Creating <| (f m)
    Just (Updating m) -> Editor empty fields <| Just <| Updating <| (f m)

getModel : Model model -> model
getModel (Editor _ _ value) =
  case value of
    Just (Creating m) -> m
    Just (Updating m) -> m

mapValue : (Value model -> Value model) -> Model model -> Model model
mapValue f (Editor empty fields value) =
  Editor empty fields (Maybe.map f value)

setValue : Value model -> Model model -> Model model
setValue newValue (Editor empty fields _) =
  Editor empty fields (Just newValue)

active : Model model -> Bool
active (Editor _ _ value) =
  not <| value == Nothing

setField : Model model -> Field model -> String -> Model model
setField m {name, focus} value =
  mapModel (Focus.set focus value) m

getField : Model model -> Field model -> String
getField m {focus} =
  Focus.get focus <| getModel m

-- Action

type Action model
  = UpdateField (Field model) String
  | Save
  | Cancel
  | EditThis model

-- Request

type Request model
  = Create model
  | Update model

requestFor : Model model -> Request model
requestFor (Editor _ _ value) =
  case value of
    Just (Creating m) -> Create m
    Just (Updating m) -> Update m

-- Done with this editor. Either prepare for re-use (when in Creating mode) or
-- close it completely (when in Updating mode). Ideally we should make this
-- either-or behaviour configurable.
done : Model model -> Model model
done editor =
  case editor of
    (Editor empty fields (Just (Creating m))) ->
      mapModel (always empty) editor
    (Editor empty fields (Just (Updating m))) ->
      Editor empty fields Nothing

update : Action model -> Model model -> (Model model, Maybe (Request model))
update action m =
  case action of
    Cancel ->
      done m
        |> withoutReq
    Save ->
      (done m, Just <| requestFor m)
    EditThis m' ->
      setValue (Updating m') m
        |> withoutReq
    UpdateField field value ->
      setField m field value
        |> withoutReq

withoutReq : Model model -> (Model model, Maybe (Request model))
withoutReq =
  flip (,) Nothing
