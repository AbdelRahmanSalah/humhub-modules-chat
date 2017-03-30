module Msgs exposing (..)

import Models exposing (..)
import RemoteData exposing (..)

type Msg = 
    Send ChatRoom ChatEntry
    | LoadChatEntries ChatRoom
    | OnFetchChatRooms (WebData (List ChatRoom))
    | OnFetchChatEntries (WebData (List ChatEntry))
    | NewPubNubEntry ChatEntry