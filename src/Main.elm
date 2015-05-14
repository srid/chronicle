--------------------------
-- CORE LIBRARY IMPORTS --
--------------------------
import Task         exposing (Task, ThreadID, andThen, sequence, succeed, spawn)
import Json.Decode  exposing (Decoder, list, int, string, (:=), map, object2)
import Signal       exposing (Signal, Mailbox, mailbox, send)
import List

---------------------------------
-- THIRD PARTY LIBRARY IMPORTS --
---------------------------------
import Http             exposing (Error, get)
import Html             exposing (Html, div, span, ul, li, a, text)
import Html.Attributes  exposing (href)

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

type alias Feeling =
  { how     : String
  , what    : String
  , trigger : String
  , notes   : String
  , at      : Int
  }

type alias Model = List Feeling

initialModel : Model
initialModel = []

----------
-- VIEW --
----------

viewFeeling : Feeling -> Html
viewFeeling feeling =
  li []
     [ span [] [ text feeling.what ],
       span [] [ text feeling.trigger ]
     ]

view : Model -> Html
view feelings =
  ul []
     ( List.map viewFeeling feelings )


--------------------------
-- LINKS TO HACKER NEWS --
--------------------------

allUrl : String
allUrl =
  "/feelings_dev"

-----------
-- TASKS --
-----------

getFeelings : Task Error (List Feeling)
getFeelings =
  get feelingsDecoder allUrl


getStory : Int -> Task Error ()
getStory id = get feelingDecoder allUrl
  `andThen` \story -> send newFeelingMailbox.address (Just story)


mainTask : Task Error (List Feeling)
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
  `andMap` ("at"  := int)

feelingsDecoder : Decoder (List Feeling)
feelingsDecoder = list feelingDecoder

---------------
-- MAILBOXES --
---------------

newFeelingMailbox : Mailbox Action
newFeelingMailbox =
  mailbox Nothing


mainTaskMailbox : Mailbox (Task Error (List Feeling))
mainTaskMailbox =
  mailbox mainTask

-----------
-- PORTS --
-----------

port mainTaskPort : Signal (Task Error (List Feeling))
port mainTaskPort =
  mainTaskMailbox.signal


-------------
-- ACTIONS --
-------------

type alias Action = Maybe Feeling


actions : Signal Action
actions =
  newFeelingMailbox.signal

------------
-- UPDATE --
------------

update : Action -> Model -> Model
update maybeFeeling feelings = case maybeFeeling of
  Nothing -> feelings
  Just feeling -> feelings ++ [ feeling ]


----------
-- MAIN --
----------

main : Signal Html
main =
  Signal.map view
    ( Signal.foldp update initialModel actions )
