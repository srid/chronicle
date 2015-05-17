module Chronicle.Database where

import Task         exposing (Task, ThreadID, andThen)
import Signal       exposing (Signal, Mailbox, mailbox, send)

import Http             exposing (Error, get)

import Chronicle.Model as Model
import Chronicle.Controller as Controller
import Chronicle.Components.FeelingList as FeelingList

-- Using production table
tableName : String
tableName =
  "feelings"

allUrl : String
allUrl =
  "/" ++ tableName


-- XXX: must handle error case from `get` using Result x a
getFeelings : Task Error ()
getFeelings =
  get FeelingList.decodeModel allUrl
    `andThen` \feelings ->
      feelings
      |> FeelingList.Initialize
      |> Controller.FeelingList
      |> send (.address Controller.actions)
