module Chronicle.Database where

-- Using production table
tableName : String
tableName =
  "feelings"

tableUrl : String
tableUrl =
  "/" ++ tableName
