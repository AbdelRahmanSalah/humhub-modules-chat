module Commands exposing (..)

import RemoteData exposing (..)
import Models exposing (..)
import UserPicker exposing (..)
import Urls exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


fetchMessagesList : Int -> Cmd Msg
fetchMessagesList offset =
    Http.get (allRoomsPrettyUrl offset) chatRoomsModelDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchChatRooms


userSearch : String -> Cmd Msg
userSearch keyword =
    Http.get (userSearchPrettyUrl keyword) usersSearchDecoder
        |> RemoteData.sendRequest
        |> Cmd.map (UserPickerMsg << OnFetchUserSearch)



-- getChatRoom : List Models.UserGuid -> Cmd Msg
-- getChatRoom usersGuid =
--     Http.post getChatRoomPrettyUrl chatRoomDecoder
--         |> RemoteData.sendRequest
--         |> Cmd.map OnFetchChatRoomSearch


chatRoomsDecoder : Decode.Decoder (List ChatRoom)
chatRoomsDecoder =
    Decode.list chatRoomDecoder


chatRoomsModelDecoder : Decode.Decoder (List ChatRoomModel)
chatRoomsModelDecoder =
    Decode.list chatRoomModelDecoder


usersSearchDecoder : Decode.Decoder (List UserPicker.UserSearch)
usersSearchDecoder =
    Decode.list userSearchDecoder


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


userSearchDecoder : Decode.Decoder UserPicker.UserSearch
userSearchDecoder =
    decode UserPicker.UserSearch
        |> required "id" Decode.int
        |> required "guid" Decode.string
        |> required "disabled" Decode.bool
        |> required "displayName" Decode.string
        |> required "image" Decode.string
        |> required "link" Decode.string
        |> required "priority" Decode.int
