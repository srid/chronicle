-- Module for working with https://github.com/srid/spas (PostgREST)

module Util.Spas where

import Task
import String
import Task exposing (Task)
import Json.Decode as JD

import Http
import Util.Http as Http2

select : String -> JD.Decoder value -> Task Http.Error value
select tableName decoder =
  Http.get decoder (urlFor tableName)

singleInsert : String -> String -> Task Http.Error String
singleInsert tableName jsonBody =
  post (urlFor tableName) (Http.string jsonBody)

update : String -> List String -> String -> Task Http.Error String
update tableName where' jsonBody =
  patch (url tableName where') (Http.string jsonBody)

urlFor : String -> String
urlFor tableName =
  "/" ++ tableName

url : String -> List String -> String
url tableName where' =
  let
    baseUrl = urlFor tableName
    query = whereToQuery where'
  in
    baseUrl ++ "?" ++ query

whereToQuery : List String -> String
whereToQuery where' =
  String.join "&" where'

-- Like Http.post but discard response body, returning empty string.
-- Workaround for https://github.com/evancz/elm-http/issues/5
post : String -> Http.Body -> Task Http.Error String
post url body =
  Http.post JD.string url body
  |> discardJsonErrors

-- TODO: implement it
patch : String -> Http.Body -> Task Http.Error String
patch url body =
  Http2.patch JD.string url body
  |> discardJsonErrors

discardJsonErrors : Task Http.Error String -> Task Http.Error String
discardJsonErrors task =
  task `Task.onError` (\err ->
    case err of
      (Http.UnexpectedPayload _) -> Task.succeed ""
      otherwise                  -> Task.fail    err)
