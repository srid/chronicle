module Chronicle.Data.MomentGroup where

import Set
import List
import String
import Time
import Date
import Util.List exposing (groupBy)
import Util.Date as Date2

import Chronicle.Data.Moment exposing (Moment, How(..), isFelicitous)

type alias MomentGroup = (String, List Moment)

nightOwlOffset : Time.Time
nightOwlOffset = 4 * Time.hour  -- Until 4am.

groupMomentsByDay : List Moment -> List MomentGroup
groupMomentsByDay =
  groupBy dayOf

-- Compute overall 'how' of a set of moments
howAggregate : (List Moment) -> How
howAggregate moments =
  let
    howSet = Set.fromList <| List.map (toString << .how) moments
    goodCount = moments |> List.map .how |> List.filter isFelicitous |> List.length
    worserCount = moments |> List.map .how |> List.filter (not << isFelicitous) |> List.length
  in
    -- If there is even at least one Great entry, mark overall day as great, for future recall purposes.
    -- Do the same for Terrible entry.
    -- If 'Good' exceeds the number of Meh,Bad,Terrible, mark it as Good
    if | Set.member (toString Great) howSet     -> Great
       | Set.member (toString Terrible) howSet  -> Terrible
       | goodCount > worserCount                -> Good
       | Set.member (toString Bad) howSet       -> Bad
       | otherwise                              -> Meh

dayOf : Moment -> String
dayOf moment =
  let
    at = Date2.subtract moment.at nightOwlOffset
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
