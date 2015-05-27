module Chronicle.Model where

import Chronicle.Database exposing (tableName)
import Chronicle.Data.Moment as Moment
import Chronicle.Components.Search as Search
import Chronicle.Components.MomentList as MomentList
import Chronicle.Components.MomentEditor as MomentEditor
import Chronicle.UI.Editor as Editor

type alias Model =
  { tableName  : String
  , demoMode   : Bool
  , search     : Search.Model
  , addMoment  : MomentEditor.Model
  , momentList : MomentList.Model
  }

initialModel : Model
initialModel = { tableName   = tableName
               , demoMode    = False -- TODO: expose this to View
               , search      = Search.initialModel
               , addMoment   = MomentEditor.initialModel Editor.Creating
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
