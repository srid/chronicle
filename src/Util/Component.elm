-- Helper to work with Elm components

module Util.Component where

import Maybe

updateInner : (action -> model -> (model, Maybe request))
            -> (request -> outterRequest)
            -> (model -> outterModel)
            -> action
            -> model
            -> (outterModel, Maybe outterRequest)
updateInner update' convertRequest convertModel a =
  mapTuple convertModel (Maybe.map convertRequest) << update' a


mapTuple : (a -> x) -> (b -> y) -> (a, b) -> (x, y)
mapTuple f g pair =
  (f <| fst pair, g <| snd pair)
