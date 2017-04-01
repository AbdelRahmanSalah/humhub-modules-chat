module Urls exposing (..)

allRoomsUrl : Int -> String
allRoomsUrl offset = "/index.php?r=chat%2Findex%2Fget-rooms" ++ (toString offset)
