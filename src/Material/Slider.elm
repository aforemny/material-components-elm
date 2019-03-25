module Material.Slider exposing (Config, slider, sliderConfig)

import Html exposing (Html, text)
import Html.Attributes exposing (class, style)
import Html.Events
import Json.Decode as Decode
import Svg
import Svg.Attributes



-- TODO: Prevent FOUC
-- TODO: Default values for min, max, step


type alias Config msg =
    { discrete : Bool
    , displayMarkers : Bool
    , min : Float
    , max : Float
    , step : Maybe Float
    , value : Float
    , disabled : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , onChange : Maybe (Float -> msg)
    }


sliderConfig : Config msg
sliderConfig =
    { discrete = False
    , displayMarkers = False
    , min = 0
    , max = 100
    , step = Nothing
    , value = 0
    , disabled = False
    , additionalAttributes = []
    , onChange = Nothing
    }


slider : Config msg -> Html msg
slider config =
    Html.node "mdc-slider"
        (List.filterMap identity
            [ rootCs
            , displayCss
            , discreteCs config
            , displayMarkersCs config
            , tabIndexAttr
            , sliderRoleAttr
            , discreteAttr config
            , valueAttr config
            , minAttr config
            , maxAttr config
            , stepAttr config
            , disabledAttr config
            , ariaValueMinAttr config
            , ariaValueMaxAttr config
            , ariaValuenowAttr config
            , changeHandler config
            ]
            ++ config.additionalAttributes
        )
        [ trackContainerElt
        , thumbContainerElt config
        ]


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-slider")


displayCss : Maybe (Html.Attribute msg)
displayCss =
    Just (style "display" "block")


discreteCs : Config msg -> Maybe (Html.Attribute msg)
discreteCs { discrete } =
    if discrete then
        Just (class "mdc-slider--discrete")

    else
        Nothing


discreteAttr : Config msg -> Maybe (Html.Attribute msg)
discreteAttr { discrete } =
    if discrete then
        Just (Html.Attributes.attribute "discrete" "")

    else
        Nothing


displayMarkersCs : Config msg -> Maybe (Html.Attribute msg)
displayMarkersCs { discrete, displayMarkers } =
    if discrete && displayMarkers then
        Just (class "mdc-slider--display-markers")

    else
        Nothing


tabIndexAttr : Maybe (Html.Attribute msg)
tabIndexAttr =
    Just (Html.Attributes.tabindex 0)


sliderRoleAttr : Maybe (Html.Attribute msg)
sliderRoleAttr =
    Just (Html.Attributes.attribute "role" "slider")


valueAttr : Config msg -> Maybe (Html.Attribute msg)
valueAttr { value } =
    Just (Html.Attributes.attribute "value" (String.fromFloat value))


minAttr : Config msg -> Maybe (Html.Attribute msg)
minAttr { min } =
    Just (Html.Attributes.attribute "min" (String.fromFloat min))


maxAttr : Config msg -> Maybe (Html.Attribute msg)
maxAttr { max } =
    Just (Html.Attributes.attribute "max" (String.fromFloat max))


stepAttr : Config msg -> Maybe (Html.Attribute msg)
stepAttr { step, discrete } =
    step
        |> Maybe.withDefault
            (if discrete then
                1

             else
                0
            )
        |> String.fromFloat
        |> Html.Attributes.attribute "step"
        |> Just


disabledAttr : Config msg -> Maybe (Html.Attribute msg)
disabledAttr { disabled } =
    if disabled then
        Just (Html.Attributes.attribute "disabled" "")

    else
        Nothing


ariaValueMinAttr : Config msg -> Maybe (Html.Attribute msg)
ariaValueMinAttr { min } =
    Just (Html.Attributes.attribute "aria-valuemin" (String.fromFloat min))


ariaValueMaxAttr : Config msg -> Maybe (Html.Attribute msg)
ariaValueMaxAttr { max } =
    Just (Html.Attributes.attribute "aria-valuemax" (String.fromFloat max))


ariaValuenowAttr : Config msg -> Maybe (Html.Attribute msg)
ariaValuenowAttr { value } =
    Just (Html.Attributes.attribute "aria-valuenow" (String.fromFloat value))


changeHandler : Config msg -> Maybe (Html.Attribute msg)
changeHandler config =
    Maybe.map
        (\handler ->
            Html.Events.on "change"
                (Decode.map handler
                    (Decode.map (Maybe.withDefault 0)
                        (Decode.map String.toFloat Html.Events.targetValue)
                    )
                )
        )
        config.onChange


trackContainerElt : Html msg
trackContainerElt =
    Html.div [ class "mdc-slider__track-container" ] [ trackElt, trackMarkerContainerElt ]


trackElt : Html msg
trackElt =
    Html.div [ class "mdc-slider__track" ] []


trackMarkerContainerElt : Html msg
trackMarkerContainerElt =
    Html.div [ class "mdc-slider__track-marker-container" ] []


thumbContainerElt : Config msg -> Html msg
thumbContainerElt { discrete } =
    Html.div [ class "mdc-slider__thumb-container" ]
        (if discrete then
            [ pinElt, thumbElt, focusRingElt ]

         else
            [ thumbElt, focusRingElt ]
        )


pinElt : Html msg
pinElt =
    Html.div [ class "mdc-slider__pin" ] [ pinValueMarkerElt ]


pinValueMarkerElt : Html msg
pinValueMarkerElt =
    Html.div [ class "mdc-slider__pin-value-marker" ] []


thumbElt : Html msg
thumbElt =
    Svg.svg
        [ Svg.Attributes.class "mdc-slider__thumb"
        , Svg.Attributes.width "21"
        , Svg.Attributes.height "21"
        ]
        [ Svg.circle
            [ Svg.Attributes.cx "10.5"
            , Svg.Attributes.cy "10.5"
            , Svg.Attributes.r "7.875"
            ]
            []
        ]


focusRingElt : Html msg
focusRingElt =
    Html.div [ class "mdc-slider__focus-ring" ] []