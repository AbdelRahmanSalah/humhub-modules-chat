module Urls exposing (..)

import Http


allRoomsUrl : Int -> String
allRoomsUrl offset =
    url "/index.php" [ ( "r", "chat/index/get-rooms" ), ( "offset", toString offset ) ]

allRoomsPrettyUrl : Int -> String 
allRoomsPrettyUrl offset = 
    url "/chat/index/get-rooms" [ ( "offset", toString offset ) ]

userSearchUrl : String -> String
userSearchUrl keyword =
    url "/index.php" [ ( "r", "user/search/json" ), ( "keyword", keyword ) ]

userSearchPrettyUrl : String -> String
userSearchPrettyUrl keyword =
    url "/user/search/json" [ ( "keyword", keyword ) ]


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
