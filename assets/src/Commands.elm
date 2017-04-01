
module Commands exposing (..)

import RemoteData exposing (..)
import Msgs exposing (..)
import Models exposing (..)
import Urls exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, hardcoded)

fetchMessagesList : Int -> Cmd Msg
fetchMessagesList offset = 
    Http.get (allRoomsUrl offset) chatRoomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchChatRooms 

chatRoomsDecoder : Decode.Decoder (List ChatRoom)
chatRoomsDecoder =
    Decode.list chatRoomDecoder


chatRoomDecoder : Decode.Decoder ChatRoom
chatRoomDecoder =
    decode ChatRoom
        |> required "guid" Decode.string
        |> required "title" Decode.string
        |> hardcoded Nothing

chatEntryDecoder : Decode.Decoder ChatEntry
chatEntryDecoder = 
    decode ChatEntry
        |> required "guid" Decode.string
        |> required "message" Decode.string
        |> required "createdAt" Decode.string

userDecoder : Decode.Decoder User
userDecoder = 
    decode User
        |> required "name" Decode.string 
        |> required "guid" Decode.string 
        |> required "profileImg" Decode.string
        |> required "profileLink" Decode.string

chatRoomModelDecoder : Decode.Decoder ChatRoomModel
chatRoomModelDecoder = 
    decode ChatRoomModel
        |> required "chatRoom" chatRoomDecoder
        |> hardcoded Nothing
        |> hardcoded Nothing
