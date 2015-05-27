module Chronicle.Components.MomentEditView where

import Signal exposing (Address)

import Html exposing (Html)

import Chronicle.Controller as Controller
import Chronicle.Components.MomentEdit as MomentEdit
import Chronicle.UI.EditorView as EditorView

view : Address Controller.Action
    -> (MomentEdit.Action -> Controller.Action)
    -> MomentEdit.Model
    -> Html
view address toAction editModel =
  EditorView.view address toAction editModel
