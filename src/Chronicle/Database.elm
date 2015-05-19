module Chronicle.Database where

-- Using production table
tableName : String
tableName =
  "feelings_dev"

tableUrl : String
tableUrl =
  "/" ++ tableName
