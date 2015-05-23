module Chronicle.Database where

import Date

import Task exposing (Task)
import Http

import Util.Spas as Spas
import Chronicle.Data.Feeling exposing (Feeling, decodeFeelingList)
import Chronicle.Data.Feeling as Feeling

-- Using production table
tableName : String
tableName =
  "feelings"

select : Task Http.Error (List Feeling)
select =
  Spas.select tableName decodeFeelingList


insert : Feeling -> Task Http.Error String
insert
  = Feeling.encodeWithoutAt
  >> Spas.singleInsert tableName

update : Feeling -> Date.Date -> Task Http.Error String
update feeling at =
  Feeling.encodeWithoutAt feeling
  |> Spas.update tableName ["at=eq." ++ toString at]
