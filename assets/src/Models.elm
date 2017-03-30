module Models exposing (..)

import RemoteData exposing (..)

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
  ,   lastEntry : ChatEntry
  }

setLastEntry: ChatEntry -> ChatRoom -> ChatRoom
setLastEntry chatEntry chatRoom = 
  { chatRoom | lastEntry = chatEntry }

type alias User = 
  {
      name : String
  ,   profileImg : String
  ,   profileLink : String
  }

type alias ChatRoomGuid = String

type alias ChatEntryModel = 
  {
    chatEntry: ChatEntry
  , user: User
  }

type alias ChatEntry =  
  {
      guid : ChatEntryGuid
  ,   message : String
  ,   createdAt : String
  ,   chatRoomGuid : ChatRoomGuid
  }

type alias ChatEntryGuid = String