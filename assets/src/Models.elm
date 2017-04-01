module Models exposing (..)

import RemoteData exposing (..)
import Uuid exposing (..)

type alias Model = 
  {
    chatRoomList : WebData (List ChatRoom)
  , currentChatRoom : Maybe ChatRoom
  }

initModel : Model
initModel =
  {
    chatRoomList = RemoteData.Loading
  , currentChatRoom = Nothing
  }

type alias ChatRoomModel = 
  {
    chatRoom: ChatRoom
  , chatEntries : Maybe (WebData (List ChatEntry))
  , chatInput : Maybe String
  }

setChatEntries: Maybe (WebData(List ChatEntry)) -> ChatRoomModel -> ChatRoomModel 
setChatEntries chatEntries chatRoomModel = 
  { chatRoomModel | chatEntries = chatEntries }

setChatEntryInList: Maybe (WebData ChatEntry) -> ChatRoomModel -> ChatRoomModel 
setChatEntryInList chatEntry chatRoomModel = 
  { chatRoomModel | 
    chatEntries = Maybe.map2 (\a b ->
      case a of
        Success sChatEntries ->
          case b of
            Success chatEntry -> Success (sChatEntries ++ [chatEntry])
            _ -> a 
        _ -> a
    ) chatRoomModel.chatEntries chatEntry  
  }
      


type alias ChatRoom = 
  {
      guid : ChatRoomGuid 
  ,   title : String
  ,   lastEntry : Maybe (WebData ChatEntry)
  }

-- type alias ChatRoomGuid = Uuid
type alias ChatRoomGuid = String

setLastEntry: WebData ChatEntry -> ChatRoom -> ChatRoom
setLastEntry chatEntry chatRoom = 
  { chatRoom | lastEntry = Just chatEntry }

type alias User = 
  {
      name : String
  ,   guid : UserGuid
  ,   profileImg : String
  ,   profileLink : String
  }

-- type alias UserGuid = Uuid
type alias UserGuid = String

type alias ChatEntryModel = 
  {
    chatEntry: ChatEntry
  , user: User
  , chatRoomGuid: ChatRoomGuid
  }

setUser: User -> ChatEntryModel -> ChatEntryModel
setUser user chatEntryModel =
  { chatEntryModel | user = user }

setChatEntry: ChatEntry -> ChatEntryModel -> ChatEntryModel
setChatEntry chatEntry chatEntryModel =
  { chatEntryModel | chatEntry = chatEntry }

type alias ChatEntry =  
  {
      guid : ChatEntryGuid
  ,   message : String
  ,   createdAt : String
  }

-- type alias ChatEntryGuid = Uuid
type alias ChatEntryGuid = String