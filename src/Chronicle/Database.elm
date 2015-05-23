module Chronicle.Database where

import Task exposing (Task)
import Http

import Util.Http exposing (postDiscardBody)
import Chronicle.Data.Feeling exposing (Feeling)
import Chronicle.Data.Feeling as Feeling

-- Using production table
tableName : String
tableName =
  "feelings"

tableUrl : String
tableUrl =
  "/" ++ tableName

insert : Feeling -> Task Http.Error String
insert
  = Feeling.encode
  >> Http.string
  >> postDiscardBody tableUrl
