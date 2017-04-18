module Models exposing (..)

import RemoteData exposing (..)
import Navigation exposing (Location)
import Uuid exposing (..)
import Html exposing (..)
import UserPicker exposing (..)


type Msg
    = NoOp
    | Send ChatEntryModel
    | LoadChatEntries ChatRoom
    | OnFetchChatRooms (WebData (List ChatRoomModel))
    | OnFetchChatEntries (WebData (List ChatEntry))
    | NewPubNubEntry ChatEntry
    | CreateNewChatRoom
    | UserPickerMsg UserPickerMsg
    | OnLocationChange Location
    | NewRoute Route
    | OnFetchChatRoomSearch (Maybe ChatRoom)


type UserPickerMsg
    = SearchUsers String
    | UserSearchSelected UserSearch
    | RemoveUserFromPicker UserSearch
    | OnFetchUserSearch (WebData (List UserSearch))


type alias Model =
    { chatRoomList : WebData (List ChatRoomModel)
    , currentChatRoom : Maybe ChatRoomModel
    , showNewMessage : Bool
    , userPickerModel : Maybe (UserPickerModel Msg)
    , route : Route
    }


type alias ChatRoom =
    { guid : ChatRoomGuid
    , title : String
    , lastEntry : Maybe (WebData ChatEntryModel)
    }



-- type alias ChatRoomGuid = Uuid


type alias ChatRoomGuid =
    String


type Route
    = NewChatRoomRoute
    | ChatRoomRoute String
    | NotFoundRoute


type alias ChatRoomModel =
    { chatRoom : ChatRoom
    , chatEntries : Maybe (WebData (List ChatEntryModel))
    , chatInput : Maybe String
    }


type alias User =
    { name : String
    , guid : UserGuid
    , profileImg : String
    , profileLink : String
    }



-- type alias UserGuid = Uuid


type alias UserGuid =
    String


type alias ChatEntryModel =
    { chatEntry : ChatEntry
    , user : User
    , chatRoomGuid : ChatRoomGuid
    }


type alias ChatEntry =
    { guid : ChatEntryGuid
    , message : String
    , createdAt : String
    }



-- type alias ChatEntryGuid = Uuid


type alias ChatEntryGuid =
    String


initModel : Route -> Model
initModel route =
    { chatRoomList = RemoteData.Loading
    , currentChatRoom = Nothing
    , showNewMessage = False
    , userPickerModel = Nothing
    , route = route
    }


initUserPickerModel : UserPickerModel Msg
initUserPickerModel =
    { input = Nothing
    , users = Nothing -- The data you want to list and filter
    , selectedUsers = Nothing
    , onType = (UserPickerMsg << SearchUsers)
    , onSelect = (UserPickerMsg << UserSearchSelected)
    , onRemoveUser = (UserPickerMsg << RemoveUserFromPicker)
    , loader = text "Hello"
    , placeHolder = Nothing
    }


setChatEntries : Maybe (WebData (List ChatEntryModel)) -> ChatRoomModel -> ChatRoomModel
setChatEntries chatEntries chatRoomModel =
    { chatRoomModel | chatEntries = chatEntries }


setChatEntryInList : Maybe (WebData ChatEntryModel) -> ChatRoomModel -> ChatRoomModel
setChatEntryInList chatEntry chatRoomModel =
    { chatRoomModel
        | chatEntries =
            Maybe.map2
                (\a b ->
                    case a of
                        Success sChatEntries ->
                            case b of
                                Success chatEntry ->
                                    Success (sChatEntries ++ [ chatEntry ])

                                _ ->
                                    a

                        _ ->
                            a
                )
                chatRoomModel.chatEntries
                chatEntry
    }


setLastEntry : WebData ChatEntryModel -> ChatRoom -> ChatRoom
setLastEntry chatEntryModel chatRoom =
    { chatRoom | lastEntry = Just chatEntryModel }


getChatEntryModel : Maybe (WebData ChatEntryModel) -> Maybe ChatEntryModel
getChatEntryModel mayWebChatEntryModel =
    case mayWebChatEntryModel of
        Just webChatEntryModel ->
            case webChatEntryModel of
                NotAsked ->
                    Nothing

                Loading ->
                    Nothing

                Success chatEntryModel ->
                    Just chatEntryModel

                Failure err ->
                    Nothing

        Nothing ->
            Nothing


setUser : User -> ChatEntryModel -> ChatEntryModel
setUser user chatEntryModel =
    { chatEntryModel | user = user }


setChatEntry : ChatEntry -> ChatEntryModel -> ChatEntryModel
setChatEntry chatEntry chatEntryModel =
    { chatEntryModel | chatEntry = chatEntry }


setSearchInput : String -> Model -> Model
setSearchInput searchText model =
    { model
        | userPickerModel =
            (case model.userPickerModel of
                Just picker ->
                    let
                        x =
                            Debug.log "pikcer" picker
                    in
                        Just { picker | input = Just searchText, users = Nothing }

                Nothing ->
                    Just { initUserPickerModel | input = Just searchText }
            )
    }


setNewSelectedUser : UserSearch -> Model -> Model
setNewSelectedUser selectedUser model =
    { model
        | userPickerModel =
            Maybe.map
                (\a ->
                    { a
                        | selectedUsers =
                            (case a.selectedUsers of
                                Just users ->
                                    Just (users ++ [ selectedUser ])

                                Nothing ->
                                    Just ([ selectedUser ])
                            )
                        , users = Nothing
                        , input = Nothing
                    }
                )
                model.userPickerModel
    }


setTypeAheadUsers : WebData (List UserSearch) -> Model -> Model
setTypeAheadUsers userSearchResult model =
    { model
        | userPickerModel =
            Maybe.map
                (\a -> { a | users = filterSelectedUsers a.selectedUsers (Just userSearchResult) })
                model.userPickerModel
    }


filterSelectedUsers : Maybe (List UserSearch) -> Maybe (WebData (List UserSearch)) -> Maybe (WebData (List UserSearch))
filterSelectedUsers mUsers mWUsers =
    case mUsers of
        Just users ->
            Maybe.map
                (\wUsers ->
                    RemoteData.map
                        (\usersSearch ->
                            diff2List usersSearch users
                        )
                        wUsers
                )
                mWUsers

        Nothing ->
            mWUsers


diff2List : List a -> List a -> List a
diff2List xs ys =
    List.filter (not << flip List.member ys) xs
