module Model where

import Util exposing (groupBy)

type alias Model =
  List Feeling

type alias Feeling =
  { how     : String
  , what    : String
  , trigger : String
  , notes   : String
  , at      : String
  , day     : String
  }

initialModel : Model
initialModel = []


-- Grouping type

type alias DayFeelings = (String, (List Feeling))

groupFeelings : (List Feeling) -> (List DayFeelings)
groupFeelings =
  groupBy .day
