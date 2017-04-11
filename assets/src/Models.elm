module Models exposing (..)

import RemoteData exposing (..)
import Uuid exposing (..)


type alias Model =
    { chatRoomList : WebData (List ChatRoomModel)
    , currentChatRoom : Maybe ChatRoomModel
    , showNewMessage : Bool
    , userPickerSearch : Maybe UserTypeAhead
    , route : Route
    }


type alias UserTypeAhead =
    { input : String
    , users : Maybe (WebData (List UserSearch)) -- The data you want to list and filter
    , selectedUsers : Maybe (List UserSearch)
    }

type Route
    = NewChatRoomRoute
    | ChatRoomRoute String
    | NotFoundRoute


initModel : Route -> Model
initModel route =
    { chatRoomList = RemoteData.Loading
    , currentChatRoom = Nothing
    , showNewMessage = False
    , userPickerSearch = Nothing
    , route = route
    }


type alias ChatRoomModel =
    { chatRoom : ChatRoom
    , chatEntries : Maybe (WebData (List ChatEntryModel))
    , chatInput : Maybe String
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


type alias ChatRoom =
    { guid : ChatRoomGuid
    , title : String
    , lastEntry : Maybe (WebData ChatEntryModel)
    }



-- type alias ChatRoomGuid = Uuid


type alias ChatRoomGuid =
    String


setLastEntry : WebData ChatEntryModel -> ChatRoom -> ChatRoom
setLastEntry chatEntryModel chatRoom =
    { chatRoom | lastEntry = Just chatEntryModel }


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


type alias ChatEntry =
    { guid : ChatEntryGuid
    , message : String
    , createdAt : String
    }



-- type alias ChatEntryGuid = Uuid


type alias ChatEntryGuid =
    String


type alias UserSearch =
    { id : Int
    , guid : UserGuid
    , disabled : Bool
    , displayName : String
    , image : String
    , link : String
    , priority : Int
    }


setSearchInput : String -> Model -> Model
setSearchInput searchText model =
    { model
        | userPickerSearch =
            (case model.userPickerSearch of
                Just picker ->
                    Just { picker | input = searchText, users = Nothing }

                Nothing ->
                    Just { input = searchText, users = Nothing, selectedUsers = Nothing }
            )
    }


setNewSelectedUser : UserSearch -> Model -> Model
setNewSelectedUser selectedUser model =
    { model
        | userPickerSearch =
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
                        , input = ""
                        , users = Nothing
                    }
                )
                model.userPickerSearch
    }


setTypeAheadUsers : WebData (List UserSearch) -> Model -> Model
setTypeAheadUsers userSearchResult model =
    { model
        | userPickerSearch =
            Maybe.map
                (\a -> { a | users = filterSearchUserResultBySelectedUser a.selectedUsers (Just userSearchResult) })
                model.userPickerSearch
    }


filterSearchUserResultBySelectedUser : Maybe (List UserSearch) -> Maybe (WebData (List UserSearch)) -> Maybe (WebData (List UserSearch))
filterSearchUserResultBySelectedUser mUsers mWUsers =
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
