module Chronicle.Model where

import List
import Set
import String
import Date
import Json.Decode  as J
import Json.Decode exposing ((:=))

import Util.Json as JU
import Util.List exposing (groupBy)
import Chronicle.Components.Search as SearchComponent

type alias Model =
  { feelings : List Feeling
  , keywords : SearchComponent.Model
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

isFelicitous : How -> Bool
isFelicitous how =
  case how of
    Great       -> True
    Good        -> True
    otherwise   -> False

computeModel : Model -> (List DayFeelings)
computeModel {feelings, keywords} =
  groupFeelings <| SearchComponent.search keywords feelingToString feelings

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
    , --}
      Date.dayOfWeek at |> toString
    , ", "
    , Date.month at |> toString
    , " "
    , Date.day at   |> toString
    , " "
    ]

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

decodeModel : J.Decoder (List Feeling)
decodeModel = J.list decodeFeeling

initialModel : Model
initialModel = { feelings=[]
               , keywords=SearchComponent.initialModel
               }


-- Grouping type

type alias DayFeelings = (String, (List Feeling))

groupFeelings : (List Feeling) -> (List DayFeelings)
groupFeelings =
  groupBy dayOf

-- Compute overall 'how' of a set of feelings
howAggregate : (List Feeling) -> How
howAggregate feelings =
  let
    howSet = Set.fromList <| List.map (toString << .how) feelings
    goodCount = feelings |> List.map .how |> List.filter isFelicitous |> List.length
    worserCount = feelings |> List.map .how |> List.filter (not << isFelicitous) |> List.length
  in
    -- If there is even at least one Great entry, mark overall day as great, for future recall purposes.
    -- Do the same for Terrible entry.
    -- If 'Good' exceeds the number of Meh,Bad,Terrible, mark it as Good
    if | Set.member (toString Great) howSet     -> Great
       | Set.member (toString Terrible) howSet  -> Terrible
       | goodCount > worserCount                -> Good
       | Set.member (toString Bad) howSet       -> Bad
       | otherwise                              -> Meh
