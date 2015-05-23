-- Helper to work with Elm components

module Util.Component where

delegateTo : (action -> model -> (model, Maybe request))
          -> (model -> outterModel)
          -> (Maybe request -> Maybe outterRequest)
          -> action
          -> model
          -> (outterModel, Maybe outterRequest)
delegateTo update' convertModel convertRequest a m =
  let
    (model', request') = update' a m
  in
    (convertModel model', convertRequest request')
