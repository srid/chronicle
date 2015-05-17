module Chronicle.Model where

import List
import Set
import String
import Date
import Json.Decode  as J
import Json.Decode exposing ((:=))

import Util.Json as JU

import Chronicle.Data.Feeling exposing (feelingToString)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList

type alias Model =
  { feelings : FeelingList.Model
  , search   : Search.Model
  }

initialModel : Model
initialModel = { feelings=FeelingList.initialModel
               , search=Search.initialModel
               }

-- transform model based on its info before view rendering
transformModel : Model -> Model
transformModel model =
  let
    feelings' : FeelingList.Model
    feelings' = Search.search model.search feelingToString model.feelings
  in
    { model | feelings <- feelings' }
