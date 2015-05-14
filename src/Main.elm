--------------------------
-- CORE LIBRARY IMPORTS --
--------------------------
import Task         exposing (Task, ThreadID, andThen, sequence, succeed, spawn, onError)
import Json.Decode  exposing (Decoder, list, int, string, (:=), map, object2)
import Signal       exposing (Signal, Mailbox, mailbox, send)
import List
import Debug exposing (log)

---------------------------------
-- THIRD PARTY LIBRARY IMPORTS --
---------------------------------
import Http             exposing (Error, get)
import Html             exposing (Html, div, span, ul, li, a, em, strong, text)
import Html.Attributes  exposing (href)

import Model exposing (Model, Feeling)
import View

----------------------
-- HELPER FUNCTIONS --
----------------------

-- Convenient for decoding large JSON objects
andMap : Decoder (a -> b) -> Decoder a -> Decoder b
andMap = object2 (<|)

-- Perform a list of tasks in parallel.
-- Analogous to `sequence`
parallel : List (Task x value) -> Task y (List ThreadID)
parallel =
  sequence << List.map spawn

-----------
-- MODEL --
-----------


initialModel : Model
initialModel = []

----------
-- VIEW --
----------

view : Model -> Html
view feelings =
  ul []
     ( List.map View.viewFeeling feelings )


--------------------------
-- LINKS TO HACKER NEWS --
--------------------------

tableName : String
tableName =
  "feelings_dev"

allUrl : String
allUrl =
  "/" ++ tableName

-----------
-- TASKS --
-----------

getFeelings : Task Error ()
getFeelings =
  log "Hello" <| get feelingsDecoder allUrl
    `andThen` \feelings -> log (toString feelings) <| send newFeelingsMailbox.address (Just feelings)

mainTask : Task Error ()
mainTask = getFeelings


-------------------
-- JSON DECODING --
-------------------

feelingDecoder : Decoder Feeling
feelingDecoder = Feeling
  `map`    ("how"    := string)
  `andMap` ("what" := string)
  `andMap` ("trigger"  := string)
  `andMap` ("notes"   := string)
  `andMap` ("at"  := string)

feelingsDecoder : Decoder (List Feeling)
feelingsDecoder = list feelingDecoder

---------------
-- MAILBOXES --
---------------

mainTaskMailbox : Mailbox (Task Error ())
mainTaskMailbox =
  mailbox mainTask

newFeelingsMailbox : Mailbox (Maybe (List Feeling))
newFeelingsMailbox =
  mailbox Nothing

-----------
-- PORTS --
-----------

port mainTaskPort : Signal (Task Error ())
port mainTaskPort =
  mainTaskMailbox.signal


-------------
-- ACTIONS --
-------------

type alias Action = Maybe (List Feeling)


actions : Signal Action
actions =
  newFeelingsMailbox.signal

------------
-- UPDATE --
------------

update : Action -> Model -> Model
update maybeFeeling feelings = case maybeFeeling of
  Nothing -> feelings
  Just newFeelings -> newFeelings


----------
-- MAIN --
----------

main : Signal Html
main =
  Signal.map view
    ( Signal.foldp update initialModel actions )
