module Util.Http where

import Task exposing (Task)
import Json.Decode as Json

import Http as H
import Http exposing (..)

patch : Json.Decoder value -> String -> Body -> Task Error value
patch decoder url body =
  let request =
    { verb = "PATCH"
    , headers = []
    , url = url
    , body = body
    }
  in
    fromJson decoder (send defaultSettings request)
