module Util.Http where

import Http
import Task
import Task exposing (Task)
import Json.Decode as JD

-- Like Http.post but discard response body, returning empty string.
-- Workaround for https://github.com/evancz/elm-http/issues/5
postDiscardBody : String -> Http.Body -> Task Http.Error String
postDiscardBody url body =
  Http.post JD.string url body
  |> discardJsonErrors

discardJsonErrors : Task Http.Error String -> Task Http.Error String
discardJsonErrors task =
  task `Task.onError` (\err ->
    case err of
      (Http.UnexpectedPayload _) -> Task.succeed ""
      otherwise                  -> Task.fail    err)
