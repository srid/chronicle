module Chronicle.Data.FeelingGroup where

import Set
import List
import String
import Date
import Util.List exposing (groupBy)

import Chronicle.Data.Feeling exposing (Feeling, How(..), isFelicitous)


type alias FeelingGroup = (String, List Feeling)

groupFeelingsByDay : List Feeling -> List FeelingGroup
groupFeelingsByDay =
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
