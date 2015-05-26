module Chronicle.Database where

import Date

import Task exposing (Task)
import Http

import Util.Spas as Spas
import Chronicle.Data.Moment exposing (Moment, decodeMomentList)
import Chronicle.Data.Moment as Moment

-- Using production table
tableName : String
tableName =
  "moments"

select : Task Http.Error (List Moment)
select =
  Spas.select tableName decodeMomentList

insert : Moment -> Task Http.Error String
insert
  = Moment.encodeWithoutAt
  >> Spas.singleInsert tableName

update : Moment -> Int -> Task Http.Error String
update moment id =
  Moment.encodeWithoutAt moment
  |> Spas.update tableName ["id=eq." ++ toString id]
