module UserPicker exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)


type alias UserPickerModel msg =
    { input : Maybe String
    , users : Maybe (WebData (List UserSearch)) -- The data you want to list and filter
    , selectedUsers : Maybe (List UserSearch)
    , onType : String -> msg
    , onSelect : UserSearch -> msg
    , onRemoveUser : UserSearch -> msg
    , loader : Html msg
    , placeHolder : Maybe String
    }


type alias UserSearch =
    { id : Int
    , guid : UserGuid
    , disabled : Bool
    , displayName : String
    , image : String
    , link : String
    , priority : Int
    }


type alias UserGuid =
    String


userPicker : UserPickerModel msg -> Html msg
userPicker model =
    div [ class "form-group", id "notifyUserContainer", attribute "style" "margin-top: 15px;" ]
        [ input [ id "notifyUserInput", name "notifyUserInput", attribute "style" "display: none;", type_ "text", value "" ]
            []
        , div [ class "notifyUserInput_user_picker_container", style [ ( "position", "relative" ) ] ]
            [ ul [ class "tag_input", id "notifyUserInput_invite_tags" ]
                ((case (usersSelectedElement model model.selectedUsers) of
                    Just searchUsersElements ->
                        searchUsersElements

                    Nothing ->
                        []
                 )
                    ++ [ li [ id "notifyUserInput_tag_input" ]
                            [ input
                                [ attribute "autocomplete" "off"
                                , class "tag_input_field"
                                , id "user-picker-search"
                                , autofocus True
                                , placeholder "Type the name of a user or group"
                                , type_ "text"
                                , value
                                    (case model.input of
                                        Just val ->
                                            let
                                                x =
                                                    Debug.log "input" val
                                            in
                                                val

                                        Nothing ->
                                            let
                                                x =
                                                    Debug.log "from noting input" model
                                            in
                                                ""
                                    )
                                , onInput model.onType
                                ]
                                []
                            ]
                       ]
                )
            , ul
                [ attribute "aria-labelledby" "dropdownMenu"
                , class
                    ("dropdown-menu "
                        ++ (case model.users of
                                Just searchUsers ->
                                    ""

                                Nothing ->
                                    "hidden"
                           )
                    )
                , id "notifyUserInput_userpicker"
                , attribute "role" "menu"
                , style [ ( "position", "absolute" ), ( "display", "block" ) ]
                ]
                (case model.users of
                    Just searchUsers ->
                        case userPickerList model of
                            Just usersHtmlList ->
                                usersHtmlList

                            Nothing ->
                                []

                    Nothing ->
                        []
                )
            ]
        ]


userPickerList : UserPickerModel msg -> Maybe (List (Html msg))
userPickerList model =
    case model.users of
        Just users ->
            case users of
                NotAsked ->
                    Nothing

                Loading ->
                    Just ([ li [] [ model.loader ] ])

                Success [] ->
                    Nothing

                Success [ user ] ->
                    Just ([ userPickerElement model user "selected" ])

                Success (user :: users) ->
                    Just
                        (userPickerElement model user "selected"
                            :: List.map
                                (\u -> userPickerElement model u "")
                                users
                        )

                Failure err ->
                    Just [ li [] [ text ":( Sorry there is an error happen" ] ]

        Nothing ->
            Nothing


userPickerElement : UserPickerModel msg -> UserSearch -> String -> Html msg
userPickerElement model userSearch selectedClass =
    li
        [ class selectedClass, onClick (model.onSelect userSearch) ]
        [ a [ href "#" ]
            [ img
                [ class "img-rounded", src userSearch.image, height 20, width 20 ]
                []
            , text userSearch.displayName
            ]
        ]


usersSelectedElement : UserPickerModel msg -> Maybe (List UserSearch) -> Maybe (List (Html msg))
usersSelectedElement model userSearchs =
    case userSearchs of
        Just users ->
            Just
                (List.map
                    (\u ->
                        userSelectedElement model u
                    )
                    users
                )

        Nothing ->
            Nothing


userSelectedElement : UserPickerModel msg -> UserSearch -> Html msg
userSelectedElement model userSearch =
    li
        [ class "userInput" ]
        [ img
            [ class "img-rounded", src userSearch.image, height 24, width 24, attribute "data-src" "holder.js/24x24" ]
            []
        , text userSearch.displayName
        , i
            [ class "fa fa-times-circle", onClick (model.onRemoveUser userSearch) ]
            []
        ]


removeFromUserSelectedSearchList : UserSearch -> Maybe (List UserSearch) -> Maybe (List UserSearch)
removeFromUserSelectedSearchList user mUsers =
    Maybe.map (\users -> List.filter (\u -> u.id /= user.id) users) mUsers
