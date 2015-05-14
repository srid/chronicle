module Model where

type alias Model =
  List Feeling

type alias Feeling =
  { how     : String
  , what    : String
  , trigger : String
  , notes   : String
  , at      : String
  }
