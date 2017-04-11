port module Main exposing (..)

import Models exposing (..)
import Commands exposing (fetchMessagesList)
import View exposing (view)
import Msgs exposing (..)
import Update exposing (..)
import Ports exposing (..)
import Navigation exposing (Location)
import Routing exposing (..)
import Debug

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
        x = Debug.log "location" location
    in
        ( initModel currentRoute, fetchMessagesList 0 )


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    newChatEntry Msgs.NewPubNubEntry



-- useful when upload files
-- https://www.paramander.com/blog/using-ports-to-deal-with-files-in-elm-0-17
