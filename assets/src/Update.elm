module Update exposing (..)

import Models exposing (..)
import UserPicker exposing (..)
import Commands exposing (..)
import Ports exposing (..)
import Routing exposing (..)
import Dom exposing (focus)
import Task
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnLocationChange location ->
            ( { model | route = (parseLocation location) }, Cmd.none )

        NewRoute route ->
            ( model, Navigation.newUrl (getUrl route) )

        Send chatEntryModel ->
            ( model, sendChatMessage chatEntryModel )

        CreateNewChatRoom ->
            ( { model | showNewMessage = True }, Cmd.none )

        OnFetchChatRooms rooms ->
            ( { model | chatRoomList = rooms }, Cmd.none )

        UserPickerMsg userPickerMsg ->
            userPickerUpdate userPickerMsg model

        _ ->
            ( model, Cmd.none )


userPickerUpdate : UserPickerMsg -> Model -> ( Model, Cmd Msg )
userPickerUpdate msg model =
    case msg of
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
            ( { model | userPickerModel = Maybe.map (\a -> { a | selectedUsers = removeFromUserSelectedSearchList userSearch a.selectedUsers }) model.userPickerModel }, Cmd.none )
