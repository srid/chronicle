module Chronicle.Model where

import Chronicle.Database exposing (tableName)
import Chronicle.Data.Feeling as Feeling
import Chronicle.Components.Search as Search
import Chronicle.Components.Reload as Reload
import Chronicle.Components.FeelingList as FeelingList
import Chronicle.Components.FeelingEdit as FeelingEdit

type alias Model =
  { tableName   : String
  , demoMode    : Bool
  , search      : Search.Model
  , reload      : Reload.Model
  , feelingEdit : FeelingEdit.Model
  , feelingList : FeelingList.Model
  }

initialModel : Model
initialModel = { tableName   = tableName
               , demoMode    = False -- TODO: expose this to View
               , search      = Search.initialModel
               , reload      = Reload.initialModel
               , feelingEdit = FeelingEdit.initialModel
               , feelingList = FeelingList.initialModel
               }

-- transform model based on its info before view rendering
transformModel : Model -> Model
transformModel model =
  let
    feelings'    = model.feelingList |> .feelings
      |> Search.search model.search Feeling.feelingToString
      |> List.map (if model.demoMode then Feeling.mangle else (\x -> x))
    feelingList  = model.feelingList
    feelingList' = { feelingList | feelings <- feelings' }
  in
    { model | feelingList <- feelingList' }
