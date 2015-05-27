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
import Chronicle.UI.Editor as Editor
import Chronicle.UI.EditorView as EditorView

view : Address Controller.Action
    -> (MomentEdit.Action -> Controller.Action)
    -> MomentEdit.Model
    -> Html
view address toAction editModel =
  EditorView.view address toAction editModel
