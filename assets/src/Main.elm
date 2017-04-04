port module Main exposing (..)

import Html exposing (..)
import Models exposing (..)
import Commands exposing (fetchMessagesList)
import View exposing (view)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Update exposing (..)
import Ports exposing (..)


main : Program Never Model Msg
main =
    program
        { init = ( initModel, (fetchMessagesList 0) )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    newChatEntry Msgs.NewPubNubEntry



-- useful when upload files
-- https://www.paramander.com/blog/using-ports-to-deal-with-files-in-elm-0-17
