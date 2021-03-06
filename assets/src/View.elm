module View exposing (..)

import Models exposing (..)
import UserPicker exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)
import Routing exposing (getUrl)
import Json.Decode as Decode


view : Model -> Html Msg
view model =
    div
        [ class "row" ]
        [ div
            [ class "col-md-4" ]
            [ div
                [ class "panel panel-default" ]
                [ div
                    [ class "panel-heading" ]
                    [ text "Conversations"
                    , a
                        (onClickPage (NewChatRoomRoute))
                        [ i [ class "fa fa-pencil-square-o", attribute "aria-hidden" "true" ] []
                        ]
                    ]
                , hr [] []
                , chatRoomsPreview model
                ]
            ]
        , page model

        -- , case model.currentChatRoom of
        --     Just chatRoom ->
        --         messagesStream chatRoom
        --     Nothing ->
        --         if model.showNewMessage then
        --             newChatRoom model
        --         else
        --             loader
        ]


page : Model -> Html Msg
page model =
    case model.route of
        NewChatRoomRoute ->
            case model.userPickerModel of
                Just userPickerModel ->
                    newChatRoom model

                Nothing ->
                    newChatRoom { model | userPickerModel = Just Models.initUserPickerModel }

        _ ->
            notFoundView


chatRoomsPreview : Model -> Html Msg
chatRoomsPreview model =
    case model.chatRoomList of
        RemoteData.NotAsked ->
            ul [ id "inbox", class "media-list" ] []

        RemoteData.Loading ->
            ul [ id "inbox", class "media-list" ] []

        RemoteData.Success chatRooms ->
            if List.length chatRooms > 0 then
                ul [ id "inbox", class "media-list" ] (List.map chatRoomPreview chatRooms)
            else
                ul [ id "inbox", class "media-list" ]
                    [ li [ class "messagePreviewEntry entry" ]
                        [ text "Create your first Chat Room" ]
                    ]

        RemoteData.Failure err ->
            text ":( Sorry there is an error please reload the page"


chatRoomPreview : ChatRoomModel -> Html Msg
chatRoomPreview chatRoomModel =
    li
        [ class ("messagePreviewEntry_" ++ chatRoomModel.chatRoom.guid ++ " messagePreviewEntry entry") ]
        [ a
            -- [href "javascript:void(0)", onClick (LoadMessagesEntry message)]
            [ href "javascript:void(0)" ]
            [ div
                [ class "media" ]
                [ img
                    [ class "media-object img-rounded pull-left"
                    , attribute "data-src" "holder.js/32x32"
                    , attribute "alt" "32x32"
                    , style [ ( "width", "32px" ), ( "height", "32px" ) ]
                    , src
                        (case (getChatEntryModel chatRoomModel.chatRoom.lastEntry) of
                            Just chatEntryModel ->
                                chatEntryModel.user.profileImg

                            Nothing ->
                                ""
                        )
                    ]
                    []
                , div
                    [ class "media-body text-break" ]
                    [ h4
                        [ class "media-heading" ]
                        [ text
                            (case (getChatEntryModel chatRoomModel.chatRoom.lastEntry) of
                                Just chatEntryModel ->
                                    chatEntryModel.user.name

                                Nothing ->
                                    ""
                            )
                        ]
                    , h5 [] [ text chatRoomModel.chatRoom.title ]
                    , text
                        (case (getChatEntryModel chatRoomModel.chatRoom.lastEntry) of
                            Just chatEntryModel ->
                                chatEntryModel.chatEntry.message

                            Nothing ->
                                ""
                        )
                    ]
                ]
            ]
        ]


messageEntryView : ChatEntryModel -> Html msg
messageEntryView chatEntryModel =
    div [ class "media", style [ ( "margin-top", "0" ) ] ]
        [ a [ class "pull-left", href chatEntryModel.user.profileLink ]
            [ img [ alt "50x50", class "media-object img-rounded", attribute "data-src" "holder.js/50x50", src chatEntryModel.user.profileImg, style [ ( "width", "50px" ), ( "height", "50px" ) ] ]
                []
            ]
        , div [ class "pull-right" ]
            [ a [ class "", attribute "data-target" "#globalModal", href ("/mail/mail/edit-entry?messageEntryId=") ]
                [ i [ class "fa fa-pencil-square-o" ]
                    []
                ]
            ]
        , div [ class "media-body" ]
            [ h4 [ class "media-heading", attribute "style" "font-size: 14px;" ]
                [ text chatEntryModel.user.name
                , small []
                    [ span [ class "time", title "Mar 20, 2017 - 5:28 AM" ]
                        [ text "3 minutes ago" ]
                    ]
                ]
            , span [ class "content" ]
                [ div [ class "markdown-render" ]
                    [ p []
                        [ text chatEntryModel.chatEntry.message ]
                    ]
                ]
            ]
        , hr [] []
        ]


messagesStream : ChatRoomModel -> Html Msg
messagesStream chatRoomModel =
    div [ class "col-md-8 messages" ]
        [ div [ id "mail_message_details" ]
            [ div [ class "panel panel-default" ]
                [ div [ class "panel-heading" ]
                    [ text chatRoomModel.chatRoom.title
                    , div [ class "pull-right" ]
                        [ text ""
                        , text ""
                        , a [ class "btn btn-primary btn-sm tt", attribute "data-original-title" "Leave conversation", attribute "data-placement" "top", attribute "data-target" "#confirmModal_modal_leave_conversation_1", attribute "data-toggle" "modal", href "#", id "deleteLinkPost_modal_leave_conversation_1", attribute "style" "" ]
                            [ i [ class "fa fa-sign-out" ]
                                []
                            ]
                        , a [ href "/u/abdelrahman/" ]
                            [ img [ class "img-rounded tt img_margin", attribute "data-original-title" "abdelRahman salah", attribute "data-placement" "top", attribute "data-toggle" "tooltip", attribute "height" "29", src "/img/default_user.jpg", title "", attribute "width" "29" ]
                                []
                            ]
                        , a [ href "/u/david1986/" ]
                            [ img [ class "img-rounded tt img_margin", attribute "data-original-title" "David Roberts", attribute "data-placement" "top", attribute "data-toggle" "tooltip", attribute "height" "29", src "/img/default_user.jpg", title "", attribute "width" "29" ]
                                []
                            ]
                        ]
                    ]
                , div [ class "panel-body" ]
                    [ hr [ attribute "style" "margin-top: 0;" ]
                        []
                    , ul [ class "media-list" ] (displayEntries chatRoomModel.chatEntries)
                    , div [ class "row-fluid" ]
                        [ Html.form [ action "/mail/mail/show?id=1&_=1489984283524", id "h975204w1", method "post" ]
                            [ input [ name "_csrf", type_ "hidden", value "Zlo0NWNlVnUja2t2OiY.TA1oYVcVVhgcXmJDbDUvFB4nLWsNNRAaIQ==" ]
                                []
                            , div [ class "error-summary", attribute "style" "display:none" ]
                                [ p []
                                    [ text "Please fix the following errors:" ]
                                , ul []
                                    []
                                ]
                            , div [ class "form-group" ]
                                [ div [ class "md-editor", id "1489984285308" ]
                                    [ textarea [ class "form-control md-input", id "newMessage", name "ReplyMessage[message]", placeholder "Write an answer...", attribute "rows" "4", attribute "style" "resize: vertical;" ]
                                        []
                                    ]
                                , input [ id "fileUploaderHiddenGuidField_newMessage", name "fileUploaderHiddenGuidField", type_ "hidden", value "" ]
                                    []
                                ]
                            , hr []
                                []
                            , button [ class "btn btn-primary" ]
                                [ text "Send" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


displayEntries : Maybe (WebData (List ChatEntryModel)) -> List (Html Msg)
displayEntries msgEntries =
    case msgEntries of
        Just webDataMsgEntries ->
            case webDataMsgEntries of
                RemoteData.NotAsked ->
                    []

                RemoteData.Loading ->
                    [ loader ]

                RemoteData.Success messageEntries ->
                    List.map messageEntryView messageEntries

                RemoteData.Failure err ->
                    [ loader ]

        Nothing ->
            []


loader : Html msg
loader =
    div [ class "col-md-8 messages" ]
        [ div [ id "mail_message_details" ]
            [ div [ class "loader" ]
                []
            ]
        ]


newChatRoom : Model -> Html Msg
newChatRoom model =
    div [ class "col-md-8 messages" ]
        [ div [ id "mail_message_details" ]
            [ div [ class "panel panel-default" ]
                [ div [ class "panel-heading" ]
                    [ (case model.userPickerModel of
                        Just userPickerModel ->
                            let
                                x =
                                    Debug.log " new chat room " userPickerModel
                            in
                                userPicker userPickerModel

                        Nothing ->
                            text "Nothing"
                      )
                    ]
                , div [ class "panel-body" ]
                    [ hr [ attribute "style" "margin-top: 0;" ]
                        []
                    , ul [ class "media-list" ] []
                    , div [ class "row-fluid" ]
                        [ Html.form [ action "/mail/mail/show?id=1&_=1489984283524", id "h975204w1", method "post" ]
                            [ input [ name "_csrf", type_ "hidden", value "Zlo0NWNlVnUja2t2OiY.TA1oYVcVVhgcXmJDbDUvFB4nLWsNNRAaIQ==" ]
                                []
                            , div [ class "error-summary", attribute "style" "display:none" ]
                                [ p []
                                    [ text "Please fix the following errors:" ]
                                , ul []
                                    []
                                ]
                            , div [ class "form-group" ]
                                [ div [ class "md-editor", id "1489984285308" ]
                                    [ textarea [ class "form-control md-input", id "newMessage", name "ReplyMessage[message]", placeholder "Write an answer...", attribute "rows" "4", attribute "style" "resize: vertical;" ]
                                        []
                                    ]
                                , input [ id "fileUploaderHiddenGuidField_newMessage", name "fileUploaderHiddenGuidField", type_ "hidden", value "" ]
                                    []
                                ]
                            , hr []
                                []
                            , button [ class "btn btn-primary", id "h975204w2" ]
                                [ text "Send" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]



-- Prevent default by click and not prevent default when click ctrl :D


onClickPage : Route -> List (Attribute Msg)
onClickPage route =
    [ href (getUrl route)
    , class "btn btn-info pull-right"
    , onPreventDefaultClick (NewRoute route)
    ]


onPreventDefaultClick : msg -> Attribute msg
onPreventDefaultClick message =
    onWithOptions "click"
        { defaultOptions | preventDefault = True }
        (preventDefault2
            |> Decode.andThen (maybePreventDefault message)
        )


preventDefault2 : Decode.Decoder Bool
preventDefault2 =
    Decode.map2
        (invertedOr)
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "metaKey" Decode.bool)


maybePreventDefault : msg -> Bool -> Decode.Decoder msg
maybePreventDefault msg preventDefault =
    case preventDefault of
        True ->
            Decode.succeed msg

        False ->
            Decode.fail "Normal link"


invertedOr : Bool -> Bool -> Bool
invertedOr x y =
    not (x || y)
