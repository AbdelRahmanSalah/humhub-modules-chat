module Update exposing (..)

import Msgs exposing (..)
import Models exposing (..)
import Commands exposing (..)
import RemoteData exposing (..)
import Ports exposing (..)
import Dom exposing (focus)
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Send chatEntryModel ->
            ( model, sendChatMessage chatEntryModel )

        CreateNewChatRoom ->
            ( { model | showNewMessage = True }, Cmd.none )

        OnFetchChatRooms rooms ->
            ( { model | chatRoomList = rooms }, Cmd.none )

        SearchUsers searchInput ->
            ( model
                |> setSearchInput searchInput
            , userSearch searchInput
            )

        OnFetchUserSearch userSearchResult ->
            ( model
                |> setTypeAheadUsers userSearchResult
            , Cmd.none
            )

        UserSearchSelected selectedUser ->
            ( model
                |> setNewSelectedUser selectedUser
            , Task.attempt (always NoOp) (Dom.focus "user-picker-search")
            )

        RemoveUserFromPicker userSearch ->
            ( { model | userPickerSearch = Maybe.map (\a -> { a | selectedUsers = removeFromUserSelectedSearchList userSearch a.selectedUsers }) model.userPickerSearch }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- OnFetchChatEntries message ->
--     ({ model | currentMessage = Just message }, fetchMessageEntryList message)
-- OnFetchChatEntries chatEntries ->
--     ({model | currentMessage = Maybe.map (\a -> { a | messageEntries = Just msgEntries }) model.currentMessage }, Cmd.none)
-- NewPubNubEntry msgEntry ->
--     let
--         x = Debug.log "newentry" (toString msgEntry)
--         y = Debug.log "model" (toString model.currentMessage)
--     in
--         ({model |
--         currentMessage =
--             Maybe.map (\a ->
--                 { a | messageEntries = convert a.messageEntries (Just (Success msgEntry)) }) model.currentMessage }, Cmd.none)
-- convert: Maybe (WebData (List MessageEntry)) -> Maybe (WebData (MessageEntry)) -> Maybe (WebData (List MessageEntry))
-- convert msgEntries msgEntry =
--     Maybe.map2 (\a b ->
--         case a of
--             NotAsked -> Loading
--             Loading ->  Loading
--             Failure e -> Loading
--             Success msgs ->
--                 case b of
--                     NotAsked -> Loading
--                     Loading -> Loading
--                     Failure e -> Loading
--                     Success msg -> Success (msg :: msgs)
--      ) msgEntries msgEntry


removeFromUserSelectedSearchList : UserSearch -> Maybe (List UserSearch) -> Maybe (List UserSearch)
removeFromUserSelectedSearchList user mUsers =
    Maybe.map (\users -> List.filter (\u -> u.id /= user.id) users) mUsers
