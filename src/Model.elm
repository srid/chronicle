module Model where


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
groupFeelings feelings =
  groupBy feelings (\feeling -> .day feeling)

-- Take a sorted list and group it by some key function
groupBy : (List a) -> (a -> String) -> (List (String, (List a)))
groupBy l f =
    [("TODO(day)", l)]
