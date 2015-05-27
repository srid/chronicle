module Chronicle.Components.MomentEditorView where

import Signal exposing (Address)

import Html exposing (Html)

import Chronicle.Controller as Controller
import Chronicle.Components.MomentEditor as MomentEditor
import Chronicle.UI.EditorView as EditorView

view : Address Controller.Action
    -> (MomentEditor.Action -> Controller.Action)
    -> MomentEditor.Model
    -> Html
view address toAction editModel =
  EditorView.view address toAction editModel
