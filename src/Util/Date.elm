module Util.Date where

import Time exposing (Time)
import Date exposing (Date, toTime, fromTime)

subtract : Date -> Time -> Date
subtract date time
  = toTime date
  |> (flip (-)) time
  |> fromTime
