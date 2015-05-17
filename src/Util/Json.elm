module Util.Json where

import Json.Decode  exposing (Decoder, object2)

-- Convenient for decoding large JSON objects
andMap : Decoder (a -> b) -> Decoder a -> Decoder b
andMap = object2 (<|)
