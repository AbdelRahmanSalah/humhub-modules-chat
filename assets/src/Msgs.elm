module Msgs exposing (..)

import Models exposing (..)
import RemoteData exposing (..)


type Msg
    = NoOp
    | Send ChatEntryModel
    | LoadChatEntries ChatRoom
    | OnFetchChatRooms (WebData (List ChatRoomModel))
    | OnFetchChatEntries (WebData (List ChatEntry))
    | NewPubNubEntry ChatEntry
    | CreateNewChatRoom
    | OnFetchUserSearch (WebData (List UserSearch))
    | SearchUsers String
    | UserSearchSelected UserSearch
    | RemoveUserFromPicker UserSearch
