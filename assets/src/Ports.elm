port module Ports exposing (..)

import Models exposing (..)

-- get new chat entry from Javascript used in subscript 
port newChatEntry : (ChatEntry -> msg) -> Sub msg

-- get new Entry list from Javascript used in get history
port newChatEntries : (List (ChatEntry) -> msg) -> Sub msg

-- send chat room guid to javascript to get data of this message entries  to fire getHistory
port fetchRoomEntryList : ChatRoomGuid -> Cmd msg

-- send chat message to javascript to publish the message to channel
port sendChatMessage : ChatEntryModel -> Cmd msg