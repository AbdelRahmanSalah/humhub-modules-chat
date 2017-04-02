module Urls exposing (..)

import Http


allRoomsUrl : Int -> String
allRoomsUrl offset =
    url "/index.php?r=chat%2Findex%2Fget-rooms" [ ( "offset", toString offset ) ]


url : String -> List ( String, String ) -> String
url baseUrl query =
    case query of
        [] ->
            baseUrl

        _ ->
            let
                queryPairs =
                    query |> List.map (\( key, value ) -> Http.encodeUri key ++ "=" ++ Http.encodeUri value)

                queryString =
                    queryPairs |> String.join "&"
            in
                baseUrl ++ "?" ++ queryString
