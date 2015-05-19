module Chronicle.Data.Feeling where

import Date
import String
import Json.Decode  as J
import Json.Decode exposing ((:=))
import Json.Encode as JE

import Util.Json as JU


type alias Feeling =
  { how     : How
  , what    : String
  , trigger : String
  , notes   : String
  , at      : Date.Date
  }

type How =
  Great | Good | Meh | Bad | Terrible

isFelicitous : How -> Bool
isFelicitous how =
  case how of
    Great       -> True
    Good        -> True
    otherwise   -> False

default : Feeling
default = { how = Meh
          , what = ""
          , trigger = ""
          , notes = ""
          , at = Date.fromTime 0
          }

feelingToString : Feeling -> String
feelingToString feeling =
  String.join " " <| List.map (\f -> f feeling)
    [ toString << .how
    , .what
    , (\_ -> if feeling.trigger == "" then "" else "<-") -- To list all entries with trigger set
    , .trigger
    , .notes ]

-- JSON decoders

decodeHow : J.Decoder How
decodeHow =
  let parseHow s = case s of
    "great"     -> Ok Great
    "good"      -> Ok Good
    "meh"       -> Ok Meh
    "bad"       -> Ok Bad
    "terrible"  -> Ok Terrible
    otherwise   -> Err "Invalid `how` field"
  in
    J.customDecoder J.string parseHow

decodeFeeling : J.Decoder Feeling
decodeFeeling = Feeling
  `J.map`    ("how"      := decodeHow)
  `JU.andMap` ("what"     := J.string)
  `JU.andMap` ("trigger"  := J.string)
  `JU.andMap` ("notes"    := J.string)
  `JU.andMap` ("at"       := decodeDate)

decodeDate : J.Decoder (Date.Date)
decodeDate = J.customDecoder J.string Date.fromString

encode : Feeling -> String
encode feeling =
  [ ("how", JE.string (toString feeling.how))
  , ("what", JE.string feeling.what)
  , ("trigger", JE.string feeling.trigger)
  , ("notes", JE.string feeling.notes)
  -- Ignore 'at' and let the database use the now time.
  -- XXX: however, don't do this when editing existing fields.
  ]
  |> JE.object
  |> JE.encode 4
