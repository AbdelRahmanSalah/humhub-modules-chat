
module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (..)
import UrlParser exposing (..)

baseUrl : String
baseUrl = 
    "/chat/index/"

newChatRoomPath : String
newChatRoomPath =
    baseUrl ++ "new"


chatRoomPath : String -> String
chatRoomPath chatRoom =
    baseUrl ++ "/u/" ++ chatRoom

-- matchers : Parser (String -> a) a
-- matchers =
--     (s baseUrl </> string)

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map NewChatRoomRoute (s "chat" </> s "index" </> s "new" )
        , map ChatRoomRoute (s "chat" </> s "index" </> s "u" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            let 
                x = Debug.log "test" route
            in
                route
        Nothing ->
            NotFoundRoute

getUrl : Route -> String
getUrl route =
    case route of
        NewChatRoomRoute ->
            newChatRoomPath

        ChatRoomRoute chatRoom ->
            chatRoomPath chatRoom

        NotFoundRoute ->
            "not-found"
