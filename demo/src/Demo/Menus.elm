module Demo.Menus exposing (Model, Msg(..), defaultModel, update, view)

import Demo.CatalogPage exposing (CatalogPage)
import Html exposing (Html, text)
import Html.Attributes exposing (class, style)
import Material.Button as Button
import Material.Card as Card
import Material.IconButton as IconButton
import Material.List as List
import Material.List.Divider as ListDivider
import Material.List.Item as ListItem exposing (ListItem)
import Material.Menu as Menu
import Material.Theme as Theme
import Material.Typography as Typography
import Set exposing (Set)


type alias Model =
    { opened : Set String
    }


defaultModel : Model
defaultModel =
    { opened = Set.empty
    }


type Msg
    = Opened String
    | Closed String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Opened id ->
            { model
                | opened = Set.insert id model.opened
            }

        Closed id ->
            { model
                | opened = Set.remove id model.opened
            }


view : Model -> CatalogPage Msg
view model =
    { title = "Menu"
    , prelude = "Menus display a list of choices on a transient sheet of material."
    , resources =
        { materialDesignGuidelines = Just "https://material.io/go/design-menus"
        , documentation = Just "https://package.elm-lang.org/packages/aforemny/material-components-web-elm/latest/Material-Menu"
        , sourceCode = Just "https://github.com/material-components/material-components-web/tree/master/packages/mdc-menu"
        }
    , hero = [ heroMenu model ]
    , content =
        [ Html.h3 [ Typography.subtitle1 ] [ text "Button Menu" ]
        , buttonExample model
        , Html.h3 [ Typography.subtitle1 ] [ text "Icon Button Menu" ]
        , iconButtonExample model
        , Html.h3 [ Typography.subtitle1 ] [ text "Icon Button Menu within Card" ]
        , iconButtonWithinCardExample model
        ]
    }


buttonExample : Model -> Html Msg
buttonExample model =
    let
        id =
            "button"
    in
    Button.text
        (Button.config
            |> Button.setOnClick (Opened id)
            |> Button.setMenu
                (Just <|
                    Button.menu
                        (Menu.config
                            |> Menu.setOpen (Set.member id model.opened)
                            |> Menu.setOnClose (Closed id)
                        )
                        (menuItems { onClick = Closed id })
                )
        )
        "Open menu"


iconButtonExample : Model -> Html Msg
iconButtonExample model =
    let
        id =
            "icon-button"
    in
    IconButton.iconButton
        (IconButton.config
            |> IconButton.setOnClick (Opened id)
            |> IconButton.setMenu
                (Just <|
                    IconButton.menu
                        (Menu.config
                            |> Menu.setOpen (Set.member id model.opened)
                            |> Menu.setOnClose (Closed id)
                        )
                        (menuItems { onClick = Closed id })
                )
        )
        (IconButton.icon "menu_vert")


iconButtonWithinCardExample : Model -> Html Msg
iconButtonWithinCardExample model =
    let
        id =
            "card"
    in
    Card.card (Card.config |> Card.setAttributes [ style "width" "350px" ])
        { blocks =
            Card.primaryAction []
                [ Card.block <|
                    Html.div
                        [ style "padding" "1rem" ]
                        [ Html.h2
                            [ Typography.headline6
                            , style "margin" "0"
                            ]
                            [ text "Our Changing Planet" ]
                        , Html.h3
                            [ Typography.subtitle2
                            , Theme.textSecondaryOnBackground
                            , style "margin" "0"
                            ]
                            [ text "by Kurt Wagner" ]
                        ]
                , Card.block <|
                    Html.div
                        [ Typography.body2
                        , Theme.textSecondaryOnBackground
                        , style "padding" "0 1rem 0.5rem 1rem"
                        ]
                        [ text
                            "Visit ten places on our planet that are undergoing the biggest changes today."
                        ]
                ]
        , actions =
            Just <|
                Card.actions
                    { buttons =
                        [ Card.button Button.config "Read"
                        , Card.button Button.config "Bookmark"
                        ]
                    , icons =
                        [ Card.icon IconButton.config
                            (IconButton.icon "favorite_border")
                        , Card.icon IconButton.config
                            (IconButton.icon "share")
                        , Card.icon
                            (IconButton.config
                                |> IconButton.setOnClick (Opened id)
                                |> IconButton.setMenu
                                    (Just <|
                                        IconButton.menu
                                            (Menu.config
                                                |> Menu.setOpen
                                                    (Set.member id model.opened)
                                                |> Menu.setOnClose (Closed id)
                                            )
                                            (menuItems { onClick = Closed id })
                                    )
                            )
                            (IconButton.icon "more_vert")
                        ]
                    }
        }


menuItems : { onClick : msg } -> List (Html msg)
menuItems onClick =
    [ List.list
        (List.config
            |> List.setRipples False
            |> List.setWrapFocus True
        )
        (listItem onClick "Passionfruit")
        (List.concat
            [ List.map (listItem onClick)
                [ "Orange"
                , "Guava"
                , "Pitaya"
                ]
            , [ ListDivider.listItem ListDivider.config ]
            , List.map (listItem onClick)
                [ "Pineapple"
                , "Mango"
                , "Papaya"
                , "Lychee"
                ]
            ]
        )
    ]


listItem : { onClick : msg } -> String -> ListItem msg
listItem { onClick } label =
    ListItem.listItem (ListItem.config |> ListItem.setOnClick onClick)
        [ text label ]


heroMenu : Model -> Html msg
heroMenu model =
    Html.div
        [ class "mdc-menu-surface mdc-menu-surface--open"
        , style "position" "relative"
        , style "transform-origin" "left top 0px"
        , style "left" "0px"
        , style "top" "0px"
        , style "z-index" "0"
        ]
        [ List.list
            (List.config
                |> List.setRipples False
                |> List.setWrapFocus True
            )
            (ListItem.listItem ListItem.config [ text "A Menu Item" ])
            [ ListItem.listItem ListItem.config [ text "Another Menu Item" ]
            ]
        ]
