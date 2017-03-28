module Models exposing (..)

import RemoteData exposing (WebData)

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

type alias ChatRoom = 
  {
      guid : ChatRoomGuid 
  ,   title : String
  ,   lastEntry : ChatEntry
  }

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