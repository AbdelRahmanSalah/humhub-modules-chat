port module Main exposing (..)

import Models exposing (..)
import Commands exposing (fetchMessagesList)
import View exposing (view)
import Update exposing (..)
import Ports exposing (..)
import Navigation exposing (Location)
import Routing exposing (..)


init : Location -> ( Model, Cmd Msg )
init location =
    ( initModel (parseLocation location), fetchMessagesList 0 )


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
    newChatEntry NewPubNubEntry



-- useful when upload files
-- https://www.paramander.com/blog/using-ports-to-deal-with-files-in-elm-0-17
