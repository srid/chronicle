module Chronicle.Data.Feeling where

import Date
import String
import Set
import Json.Decode  as J
import Json.Decode exposing ((:=))
import Json.Encode as JE

import Util.Json as JU
import Util.Text exposing (mangleText)


type alias Feeling =
  { id      : Int
  , how     : How
  , what    : String
  , trigger : String
  , notes   : String
  , at      : Date.Date
  }

type How =
  Great | Good | Meh | Bad | Terrible

howValues : List How
howValues = [Great, Good, Meh, Bad, Terrible]

isFelicitous : How -> Bool
isFelicitous how =
  case how of
    Great       -> True
    Good        -> True
    otherwise   -> False

default : Feeling
default = { id = 0
          , how = Good
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

mangleWhitelist : Set.Set String
mangleWhitelist =
  Set.fromList
  [ "realization"
  , "went"
  , "great"
  , "good"
  , "enjoy"
  , "out"
  , "feeling"
  , "relaxed"
  , "coffee"
  , "hackmode"
  , "motivation"
  , "habitual"
  , "now"
  , "trigger"
  , "consistent"
  , "success"
  , "contemplation"
  , "appreciation"
  ]

mangle : Feeling -> Feeling
mangle feeling =
  let
    f = mangleText mangleWhitelist
  in
    { id      = feeling.id
    , how     = feeling.how
    , what    = f feeling.what
    , trigger = f feeling.trigger
    , notes   = f feeling.notes
    , at      = feeling.at
    }

-- JSON decoders

parseHow : String -> Result String How
parseHow s =
  case String.toLower s of
    "great"     -> Ok Great
    "good"      -> Ok Good
    "meh"       -> Ok Meh
    "bad"       -> Ok Bad
    "terrible"  -> Ok Terrible
    otherwise   -> Err "Invalid `how` field"

decodeHow : J.Decoder How
decodeHow =
  J.customDecoder J.string parseHow

decodeFeeling : J.Decoder Feeling
decodeFeeling = Feeling
  `J.map`     ("id"       := J.int)
  `JU.andMap` ("how"      := decodeHow)
  `JU.andMap` ("what"     := J.string)
  `JU.andMap` ("trigger"  := J.string)
  `JU.andMap` ("notes"    := J.string)
  `JU.andMap` ("at"       := decodeDate)

decodeFeelingList : J.Decoder (List Feeling)
decodeFeelingList = J.list decodeFeeling


decodeDate : J.Decoder (Date.Date)
decodeDate = J.customDecoder J.string Date.fromString

encodeWithoutAt : Feeling -> String
encodeWithoutAt feeling =
  [ ("how", (toString >> String.toLower >> JE.string) feeling.how)
  , ("what", JE.string feeling.what)
  , ("trigger", JE.string feeling.trigger)
  , ("notes", JE.string feeling.notes)
  -- Ignore 'at' and let the database use the now time.
  -- XXX: however, don't do this when editing existing fields.
  ]
  |> JE.object
  |> JE.encode 4
