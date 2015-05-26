module Chronicle.Model where

import Chronicle.Database exposing (tableName)
import Chronicle.Data.Moment as Moment
import Chronicle.Components.Search as Search
import Chronicle.Components.MomentList as MomentList
import Chronicle.Components.MomentEdit as MomentEdit

type alias Model =
  { tableName  : String
  , demoMode   : Bool
  , search     : Search.Model
  , addMoment  : MomentEdit.Model
  , momentList : MomentList.Model
  }

initialModel : Model
initialModel = { tableName   = tableName
               , demoMode    = False -- TODO: expose this to View
               , search      = Search.initialModel
               , addMoment   = MomentEdit.initialModel
               , momentList  = MomentList.initialModel
               }

-- transform model based on its info before view rendering
transformModel : Model -> Model
transformModel model =
  let
    moments'    = model.momentList |> .moments
      |> Search.search model.search Moment.momentToString
      |> List.map (if model.demoMode then Moment.mangle else (\x -> x))
    momentList  = model.momentList
    momentList' = { momentList | moments <- moments' }
  in
    { model | momentList <- momentList' }
