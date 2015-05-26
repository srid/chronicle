module Chronicle.Data.Moment where

import Date
import String
import Set
import Json.Decode  as J
import Json.Decode exposing ((:=))
import Json.Encode as JE

import Util.Json as JU
import Util.Text exposing (mangleText)


type alias Moment =
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

default : Moment
default = { id = 0
          , how = Good
          , what = ""
          , trigger = ""
          , notes = ""
          , at = Date.fromTime 0
          }

momentToString : Moment -> String
momentToString moment =
  String.join " " <| List.map (\f -> f moment)
    [ toString << .how
    , .what
    , (\_ -> if moment.trigger == "" then "" else "<-") -- To list all entries with trigger set
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
  , "moment"
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

mangle : Moment -> Moment
mangle moment =
  let
    f = mangleText mangleWhitelist
  in
    { id      = moment.id
    , how     = moment.how
    , what    = f moment.what
    , trigger = f moment.trigger
    , notes   = f moment.notes
    , at      = moment.at
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

decodeMoment : J.Decoder Moment
decodeMoment = Moment
  `J.map`     ("id"       := J.int)
  `JU.andMap` ("how"      := decodeHow)
  `JU.andMap` ("what"     := J.string)
  `JU.andMap` ("trigger"  := J.string)
  `JU.andMap` ("notes"    := J.string)
  `JU.andMap` ("at"       := decodeDate)

decodeMomentList : J.Decoder (List Moment)
decodeMomentList = J.list decodeMoment


decodeDate : J.Decoder (Date.Date)
decodeDate = J.customDecoder J.string Date.fromString

encodeWithoutAt : Moment -> String
encodeWithoutAt moment =
  [ ("how", (toString >> String.toLower >> JE.string) moment.how)
  , ("what", JE.string moment.what)
  , ("trigger", JE.string moment.trigger)
  , ("notes", JE.string moment.notes)
  -- Ignore 'at' and let the database use the now time.
  -- XXX: however, don't do this when editing existing fields.
  ]
  |> JE.object
  |> JE.encode 4
