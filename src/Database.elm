module Database where

import Task         exposing (Task, ThreadID, andThen)
import Signal       exposing (Signal, Mailbox, mailbox, send)

import Http             exposing (Error, get)

import Model
import Controller

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
  get Model.decodeModel allUrl
    `andThen` \feelings ->
      send (.address Controller.actions) <| Controller.Initialize feelings
