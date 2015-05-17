module Chronicle.Model where

import Chronicle.Data.Feeling exposing (feelingToString)
import Chronicle.Components.Search as Search
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit

type alias Model =
  { search      : Search.Model
  , feelingEdit : FeelingEdit.Model
  , feelings    : FeelingList.Model
  }

initialModel : Model
initialModel = { search      = Search.initialModel
               , feelingEdit = FeelingEdit.initialModel
               , feelings    = FeelingList.initialModel
               }

-- transform model based on its info before view rendering
transformModel : Model -> Model
transformModel model =
  let
    feelings' = Search.search model.search feelingToString model.feelings
  in
    { model | feelings <- feelings' }
