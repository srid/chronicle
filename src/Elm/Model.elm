module Model where

import List
import String
import Date
import Json.Decode  as J
import Json.Decode exposing ((:=))

import Search
import Util exposing (groupBy)
import Util as U

type alias Model =
  { feelings : List Feeling
  , keywords : String
  }

type alias Feeling =
  { how     : How
  , what    : String
  , trigger : String
  , notes   : String
  , at      : Date.Date
  }

type How =
  Great | Good | Meh | Bad | Terrible

computeModel : Model -> (List DayFeelings)
computeModel {feelings, keywords} =
  groupFeelings <| Search.search keywords feelingToString feelings

feelingToString : Feeling -> String
feelingToString feeling =
  String.join " " <| List.map (\f -> f feeling)
    [ toString << .how
    , .what
    , (\_ -> if feeling.trigger == "" then "" else "<-") -- To list all entries with trigger set
    , .trigger
    , .notes ]

dayOf : Feeling -> String
dayOf feeling =
  let
    at = feeling.at
  in
    String.join ""
    [ {-- Date.year at  |> toString   <- Need to uncomment in 2016 :-P
    , ", "
    , --} Date.month at |> toString
    , " "
    , Date.day at   |> toString
    , " ("
    , Date.dayOfWeek at |> toString
    , ") "
    ]

-- Compute the statistical mode of 'how' in feelings
howMode : (List Feeling) -> How
howMode feelings =
  let
    groups      = U.groupBy .how <| List.sortBy (.how >> toString) feelings
    frequencies = List.map (\(how, fl) -> (how, List.length fl)) groups
  in
    case List.head <| List.reverse <| List.sortBy snd frequencies of
      Nothing       -> Meh
      Just (how, _) -> how

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
  `U.andMap` ("what"     := J.string)
  `U.andMap` ("trigger"  := J.string)
  `U.andMap` ("notes"    := J.string)
  `U.andMap` ("at"       := decodeDate)

decodeDate : J.Decoder (Date.Date)
decodeDate = J.customDecoder J.string Date.fromString

decodeModel : J.Decoder (List Feeling)
decodeModel = J.list decodeFeeling

initialModel : Model
initialModel = { feelings=[], keywords="" }


-- Grouping type

type alias DayFeelings = (String, (List Feeling))

groupFeelings : (List Feeling) -> (List DayFeelings)
groupFeelings =
  groupBy dayOf
