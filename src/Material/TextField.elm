module Material.TextField exposing
    ( Config, config
    , setOnInput
    , setOnFocus
    , setOnBlur
    , setOnChange
    , setLabel
    , setValue
    , setPlaceholder
    , setDisabled
    , setRequired
    , setValid
    , setMinLength
    , setMaxLength
    , setPattern
    , setType
    , setMin
    , setMax
    , setStep
    , setLeadingIcon
    , setTrailingIcon
    , setPrefix
    , setSuffix
    , setEndAligned
    , setAttributes
    , filled
    , outlined
    )

{-| Text fields allow users to input, edit, and select text.


# Table of Contents

  - [Resources](#resources)
  - [Basic Usage](#basic-usage)
  - [Configuration](#configuration)
      - [Configuration Options](#configuration-options)
  - [Filled Text Field](#filled-text-field)
  - [Outlined Text Field](#outlined-text-field)
  - [Full Width Text Field](#full-width-text-field)
  - [Multiline Text Field](#multiline-text-field)
  - [Disabled Text Field](#disabled-text-field)
  - [Password Text Field](#password-text-field)
  - [Required Text Field](#disabled-text-field)
  - [Valid Text Field](#valid-text-field)
  - [Text Field with Leading Icon](#text-field-with-leading-icon)
  - [Text Field with Trailing Icon](#text-field-with-trailing-icon)
  - [Text Field with Custom Icon](#text-field-with-custom-icon)
  - [Text Field with Prefix](#text-field-with-prefix)
  - [Text Field with Suffix](#text-field-with-suffix)
  - [End Aligned Text Field](#end-aligned-text-field)
  - [Text Field with Character Counter](#text-field-with-character-counter)
  - [Focus a Text Field](#focus-a-text-field)


# Resources

  - [Demo: Text Fields](https://aforemny.github.io/material-components-web-elm/#text-field)
  - [Material Design Guidelines: Text Fields](https://material.io/components/text-fields/)
  - [MDC Web: Textfield](https://github.com/material-components/material-components-web/tree/master/packages/mdc-textfield)
  - [Sass Mixins (MDC Web)](https://github.com/material-components/material-components-web/tree/master/packages/mdc-textfield#sass-mixins)


# Basic Usage

    import Material.TextField as TextField

    type Msg
        = ValueChanged String

    main =
        TextField.filled
            (TextField.config
                |> TextField.setLabel (Just "My text field")
                |> TextField.setValue (Just "hello world")
                |> TextField.setOnInput ValueChanged
            )


# Configuration

@docs Config, config


## Configuration Options

@docs setOnInput
@docs setOnFocus
@docs setOnBlur
@docs setOnChange
@docs setLabel
@docs setValue
@docs setPlaceholder
@docs setDisabled
@docs setRequired
@docs setValid
@docs setMinLength
@docs setMaxLength
@docs setPattern
@docs setType
@docs setMin
@docs setMax
@docs setStep
@docs setLeadingIcon
@docs setTrailingIcon
@docs setPrefix
@docs setSuffix
@docs setEndAligned
@docs setAttributes


# Filled Text Field


# Filled Text Field

    TextField.filled TextField.config

@docs filled


# Outlined Text Field

Text fields may have a visible outlined around them by using their
`outlined` variant.

    TextField.outlined TextField.config

@docs outlined


# Disabled Text Field

To disable a text field, set its `setDisabled` configuration option to `True`.

    TextField.filled
        (TextField.config |> TextField.setDisabled True)


# Password Text Field

To mark a text field as an input for entering a passwort, use its `setType`
configuration option to specify `"password"`.

    TextField.filled
        (TextField.config |> TextField.setType (Just "password"))

Other input types besides `"password"` may or may not be supported.


# Required Text Field

To mark a text field as required, set its `setRequired` configuration option to
`True`.

    TextField.filled
        (TextField.config |> TextField.setRequired True)


# Valid Text Field

To mark a text field as valid, set its `setValid` configuration option to
`True`.

    TextField.filled
        (TextField.config |> TextField.setValid True)


# Text Field with Leading Icon

To have a text field display a leading icon, use its `setLeadingIcon`
configuration option to specify a value of `Icon`.

    import Material.TextField.Icon as TextFieldIcon

    TextField.filled
        (TextField.config
            |> TextField.setLeadingIcon
                (Just (TextFieldIcon.icon "wifi"))
        )


# Text Field with Trailing Icon

To have a text field display a trailing icon, use its `setTrailingIcon`
configuration option to specify a value of `Icon`.

    import Material.TextField.Icon as TextFieldIcon

    TextField.filled
        (TextField.config
            |> TextField.setTrailingIcon
                (Just (TextFieldIcon.icon "clear"))
        )


# Text Field with Custom Icon

This library natively supports [Material Icons](https://material.io/icons).
However, you may also include SVG or custom icons such as FontAwesome.

See [Material.TextField.Icon](Material-TextField-Icon) for more information.


# Text Field with Prefix

To have a text field display a prefix text such as a currency symbol, set its
`setPrefix` configuration option.

    TextField.filled
        (TextField.config
            |> TextField.setPrefix (Just "$")
        )


# Text Field with Suffix

To have a text field display a suffix text such as a unit of mass, set its
`setSuffix` configuration option.

    TextField.filled
        (TextField.config
            |> TextField.setSuffix (Just "kg")
        )


# End Aligned Text Field

To have a text field end align its input, set its `setEndAligned` configuration
option to `True`.

    TextField.filled
        (TextField.config
            |> TextField.setEndAligned True
        )


# Text Field with Character Counter

To have a text field display a character counter, specify its `setMaxLength`
configuration option, and also add a `HelperText.characterCounter` as a child
of `HelperText.helperLine`.

    [ TextField.filled
        (TextField.config |> TextField.setMaxLength (Just 18))
    , HelperText.helperLine [] [ HelperText.characterCounter [] ]
    ]


# Focus a Text Field

You may programatically focus a text field by assigning an id attribute to it
and use `Browser.Dom.focus`.

    TextField.filled
        (TextField.config
            |> TextField.setAttributes
                [ Html.Attributes.id "my-text-field" ]
        )

-}

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events
import Json.Decode as Decode
import Json.Encode as Encode
import Material.TextField.Icon.Internal as TextFieldIcon
import Svg.Attributes


{-| Configuration of a text field
-}
type Config msg
    = Config
        { label : Maybe String
        , fullwidth : Bool
        , value : Maybe String
        , placeholder : Maybe String
        , disabled : Bool
        , required : Bool
        , valid : Bool
        , minLength : Maybe Int
        , maxLength : Maybe Int
        , pattern : Maybe String
        , type_ : Maybe String
        , min : Maybe Int
        , max : Maybe Int
        , step : Maybe Int
        , leadingIcon : Maybe (TextFieldIcon.Icon msg)
        , trailingIcon : Maybe (TextFieldIcon.Icon msg)
        , prefix : Maybe String
        , suffix : Maybe String
        , endAligned : Bool
        , additionalAttributes : List (Html.Attribute msg)
        , onInput : Maybe (String -> msg)
        , onFocus : Maybe msg
        , onBlur : Maybe msg
        , onChange : Maybe (String -> msg)
        }


{-| Default configuration of a text field
-}
config : Config msg
config =
    Config
        { label = Nothing
        , fullwidth = False
        , value = Nothing
        , placeholder = Nothing
        , disabled = False
        , required = False
        , valid = True
        , minLength = Nothing
        , maxLength = Nothing
        , pattern = Nothing
        , type_ = Nothing
        , min = Nothing
        , max = Nothing
        , step = Nothing
        , leadingIcon = Nothing
        , trailingIcon = Nothing
        , prefix = Nothing
        , suffix = Nothing
        , endAligned = False
        , additionalAttributes = []
        , onInput = Nothing
        , onFocus = Nothing
        , onBlur = Nothing
        , onChange = Nothing
        }


{-| Specify a text field's label
-}
setLabel : Maybe String -> Config msg -> Config msg
setLabel label (Config config_) =
    Config { config_ | label = label }


{-| Specify a text field's value
-}
setValue : Maybe String -> Config msg -> Config msg
setValue value (Config config_) =
    Config { config_ | value = value }


{-| Specify a text field's placeholder
-}
setPlaceholder : Maybe String -> Config msg -> Config msg
setPlaceholder placeholder (Config config_) =
    Config { config_ | placeholder = placeholder }


{-| Specify a text field to be disabled

Disabled text fields cannot be interacted with and have no visual interaction
effect.

-}
setDisabled : Bool -> Config msg -> Config msg
setDisabled disabled (Config config_) =
    Config { config_ | disabled = disabled }


{-| Specify a text field to be required
-}
setRequired : Bool -> Config msg -> Config msg
setRequired required (Config config_) =
    Config { config_ | required = required }


{-| Specify a text field to be valid
-}
setValid : Bool -> Config msg -> Config msg
setValid valid (Config config_) =
    Config { config_ | valid = valid }


{-| Specify a text field's minimum length
-}
setMinLength : Maybe Int -> Config msg -> Config msg
setMinLength minLength (Config config_) =
    Config { config_ | minLength = minLength }


{-| Specify a text field's maximum length
-}
setMaxLength : Maybe Int -> Config msg -> Config msg
setMaxLength maxLength (Config config_) =
    Config { config_ | maxLength = maxLength }


{-| Specify a text field's pattern
-}
setPattern : Maybe String -> Config msg -> Config msg
setPattern pattern (Config config_) =
    Config { config_ | pattern = pattern }


{-| Specify a text field's type
-}
setType : Maybe String -> Config msg -> Config msg
setType type_ (Config config_) =
    Config { config_ | type_ = type_ }


{-| Specify a text field's minimum value
-}
setMin : Maybe Int -> Config msg -> Config msg
setMin min (Config config_) =
    Config { config_ | min = min }


{-| Specify a text field's maximum value
-}
setMax : Maybe Int -> Config msg -> Config msg
setMax max (Config config_) =
    Config { config_ | max = max }


{-| Specify a text field's step value
-}
setStep : Maybe Int -> Config msg -> Config msg
setStep step (Config config_) =
    Config { config_ | step = step }


{-| Specify a text field's leading icon
-}
setLeadingIcon : Maybe (TextFieldIcon.Icon msg) -> Config msg -> Config msg
setLeadingIcon leadingIcon (Config config_) =
    Config { config_ | leadingIcon = leadingIcon }


{-| Specify a text field's trailing icon
-}
setTrailingIcon : Maybe (TextFieldIcon.Icon msg) -> Config msg -> Config msg
setTrailingIcon trailingIcon (Config config_) =
    Config { config_ | trailingIcon = trailingIcon }


{-| Specify a text field's prefix
-}
setPrefix : Maybe String -> Config msg -> Config msg
setPrefix prefix (Config config_) =
    Config { config_ | prefix = prefix }


{-| Specify a text field's suffix
-}
setSuffix : Maybe String -> Config msg -> Config msg
setSuffix suffix (Config config_) =
    Config { config_ | suffix = suffix }


{-| Specify a text field's input to end-aligned
-}
setEndAligned : Bool -> Config msg -> Config msg
setEndAligned endAligned (Config config_) =
    Config { config_ | endAligned = endAligned }


{-| Specify additional attributes
-}
setAttributes : List (Html.Attribute msg) -> Config msg -> Config msg
setAttributes additionalAttributes (Config config_) =
    Config { config_ | additionalAttributes = additionalAttributes }


{-| Specify a message when the user changes the value inside the text field
-}
setOnInput : (String -> msg) -> Config msg -> Config msg
setOnInput onInput (Config config_) =
    Config { config_ | onInput = Just onInput }


{-| Specify a message when the user moves focus to the text field
-}
setOnFocus : msg -> Config msg -> Config msg
setOnFocus onFocus (Config config_) =
    Config { config_ | onFocus = Just onFocus }


{-| Specify a message when the user moves focus away from the text field
-}
setOnBlur : msg -> Config msg -> Config msg
setOnBlur onBlur (Config config_) =
    Config { config_ | onBlur = Just onBlur }


{-| Specify a message when the user confirms a changed value inside the text
field
-}
setOnChange : (String -> msg) -> Config msg -> Config msg
setOnChange onChange (Config config_) =
    Config { config_ | onChange = Just onChange }


{-| Filled text field view function
-}
filled : Config msg -> Html msg
filled config_ =
    textField False config_


{-| Outlined text field view function
-}
outlined : Config msg -> Html msg
outlined config_ =
    textField True config_


textField : Bool -> Config msg -> Html msg
textField outlined_ ((Config { additionalAttributes }) as config_) =
    Html.node "mdc-text-field"
        (List.filterMap identity
            [ rootCs
            , noLabelCs config_
            , filledCs outlined_
            , outlinedCs outlined_
            , fullwidthCs config_
            , labelFloatingCs config_
            , foucClassNamesProp
            , disabledCs config_
            , withLeadingIconCs config_
            , withTrailingIconCs config_
            , endAlignedCs config_
            , valueProp config_
            , disabledProp config_
            , requiredProp config_
            , validProp config_
            , patternProp config_
            , minLengthProp config_
            , maxLengthProp config_
            , minProp config_
            , maxProp config_
            , stepProp config_
            ]
            ++ additionalAttributes
        )
        (if outlined_ then
            [ leadingIconElt config_
            , prefixElt config_
            , inputElt config_
            , suffixElt config_
            , notchedOutlineElt config_
            , trailingIconElt config_
            ]

         else
            [ rippleElt
            , leadingIconElt config_
            , prefixElt config_
            , inputElt config_
            , suffixElt config_
            , labelElt config_
            , lineRippleElt
            , trailingIconElt config_
            ]
        )


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-text-field")


filledCs : Bool -> Maybe (Html.Attribute msg)
filledCs outlined_ =
    if not outlined_ then
        Just (class "mdc-text-field--filled")

    else
        Nothing


outlinedCs : Bool -> Maybe (Html.Attribute msg)
outlinedCs outlined_ =
    if outlined_ then
        Just (class "mdc-text-field--outlined")

    else
        Nothing


fullwidthCs : Config msg -> Maybe (Html.Attribute msg)
fullwidthCs (Config { fullwidth }) =
    if fullwidth then
        Just (class "mdc-text-field--fullwidth")

    else
        Nothing


disabledCs : Config msg -> Maybe (Html.Attribute msg)
disabledCs (Config { disabled }) =
    if disabled then
        Just (class "mdc-text-field--disabled")

    else
        Nothing


withLeadingIconCs : Config msg -> Maybe (Html.Attribute msg)
withLeadingIconCs (Config { leadingIcon }) =
    if leadingIcon /= Nothing then
        Just (class "mdc-text-field--with-leading-icon")

    else
        Nothing


withTrailingIconCs : Config msg -> Maybe (Html.Attribute msg)
withTrailingIconCs (Config { trailingIcon }) =
    if trailingIcon /= Nothing then
        Just (class "mdc-text-field--with-trailing-icon")

    else
        Nothing


labelFloatingCs : Config msg -> Maybe (Html.Attribute msg)
labelFloatingCs (Config { label, value, fullwidth }) =
    if not fullwidth && label /= Nothing && Maybe.withDefault "" value /= "" then
        Just (class "mdc-text-field--label-floating")

    else
        Nothing


prefixCs : Html.Attribute msg
prefixCs =
    class "mdc-text-field__affix mdc-text-field__affix--prefix"


suffixCs : Html.Attribute msg
suffixCs =
    class "mdc-text-field__affix mdc-text-field__affix--suffix"


endAlignedCs : Config msg -> Maybe (Html.Attribute msg)
endAlignedCs (Config { endAligned }) =
    if endAligned then
        Just (class "mdc-text-field--end-aligned")

    else
        Nothing


requiredProp : Config msg -> Maybe (Html.Attribute msg)
requiredProp (Config { required }) =
    Just (Html.Attributes.property "required" (Encode.bool required))


validProp : Config msg -> Maybe (Html.Attribute msg)
validProp (Config { valid }) =
    Just (Html.Attributes.property "valid" (Encode.bool valid))


minLengthProp : Config msg -> Maybe (Html.Attribute msg)
minLengthProp (Config { minLength }) =
    Just
        (Html.Attributes.property "minLength"
            (Encode.int (Maybe.withDefault -1 minLength))
        )


maxLengthProp : Config msg -> Maybe (Html.Attribute msg)
maxLengthProp (Config { maxLength }) =
    Just
        (Html.Attributes.property "maxLength"
            (Encode.int (Maybe.withDefault -1 maxLength))
        )


foucClassNamesProp : Maybe (Html.Attribute msg)
foucClassNamesProp =
    Just
        (Html.Attributes.property "foucClassNames"
            (Encode.list Encode.string
                [ "mdc-text-field--label-floating"
                ]
            )
        )


minLengthAttr : Config msg -> Maybe (Html.Attribute msg)
minLengthAttr (Config { minLength }) =
    Maybe.map (Html.Attributes.attribute "minLength" << String.fromInt) minLength


maxLengthAttr : Config msg -> Maybe (Html.Attribute msg)
maxLengthAttr (Config { maxLength }) =
    Maybe.map (Html.Attributes.attribute "maxLength" << String.fromInt) maxLength


minProp : Config msg -> Maybe (Html.Attribute msg)
minProp (Config { min }) =
    Just
        (Html.Attributes.property "min"
            (Encode.string (Maybe.withDefault "" (Maybe.map String.fromInt min)))
        )


maxProp : Config msg -> Maybe (Html.Attribute msg)
maxProp (Config { max }) =
    Just
        (Html.Attributes.property "max"
            (Encode.string (Maybe.withDefault "" (Maybe.map String.fromInt max)))
        )


stepProp : Config msg -> Maybe (Html.Attribute msg)
stepProp (Config { step }) =
    Just
        (Html.Attributes.property "step"
            (Encode.string (Maybe.withDefault "" (Maybe.map String.fromInt step)))
        )


valueProp : Config msg -> Maybe (Html.Attribute msg)
valueProp (Config { value }) =
    Maybe.map (Html.Attributes.property "value" << Encode.string) value


placeholderAttr : Config msg -> Maybe (Html.Attribute msg)
placeholderAttr (Config { placeholder }) =
    Maybe.map Html.Attributes.placeholder placeholder


rippleElt : Html msg
rippleElt =
    Html.span [ class "mdc-text-field__ripple" ] []


leadingIconElt : Config msg -> Html msg
leadingIconElt (Config { leadingIcon }) =
    iconElt "mdc-text-field__icon--leading" leadingIcon


trailingIconElt : Config msg -> Html msg
trailingIconElt (Config { trailingIcon }) =
    iconElt "mdc-text-field__icon--trailing" trailingIcon


iconElt : String -> Maybe (TextFieldIcon.Icon msg) -> Html msg
iconElt modifierCs icon_ =
    case icon_ of
        Nothing ->
            text ""

        Just (TextFieldIcon.Icon { node, attributes, nodes, onInteraction, disabled }) ->
            node
                (class "mdc-text-field__icon"
                    :: class modifierCs
                    :: (case onInteraction of
                            Just msg ->
                                if not disabled then
                                    Html.Attributes.tabindex 0
                                        :: Html.Attributes.attribute "role" "button"
                                        :: Html.Events.onClick msg
                                        :: Html.Events.on "keydown"
                                            (Html.Events.keyCode
                                                |> Decode.andThen
                                                    (\keyCode ->
                                                        if keyCode == 13 then
                                                            Decode.succeed msg

                                                        else
                                                            Decode.fail ""
                                                    )
                                            )
                                        :: attributes

                                else
                                    Html.Attributes.tabindex -1
                                        :: Html.Attributes.attribute "role" "button"
                                        :: attributes

                            Nothing ->
                                attributes
                       )
                )
                nodes

        Just (TextFieldIcon.SvgIcon { node, attributes, nodes, onInteraction, disabled }) ->
            node
                (Svg.Attributes.class "mdc-text-field__icon"
                    :: Svg.Attributes.class modifierCs
                    :: (case onInteraction of
                            Just msg ->
                                if not disabled then
                                    Html.Attributes.tabindex 0
                                        :: Html.Attributes.attribute "role" "button"
                                        :: Html.Events.onClick msg
                                        :: Html.Events.on "keydown"
                                            (Html.Events.keyCode
                                                |> Decode.andThen
                                                    (\keyCode ->
                                                        if keyCode == 13 then
                                                            Decode.succeed msg

                                                        else
                                                            Decode.fail ""
                                                    )
                                            )
                                        :: attributes

                                else
                                    Html.Attributes.tabindex -1
                                        :: Html.Attributes.attribute "role" "button"
                                        :: attributes

                            Nothing ->
                                attributes
                       )
                )
                nodes


prefixElt : Config msg -> Html msg
prefixElt (Config { prefix }) =
    case prefix of
        Just prefixStr ->
            Html.span [ prefixCs ] [ text prefixStr ]

        Nothing ->
            text ""


suffixElt : Config msg -> Html msg
suffixElt (Config { suffix }) =
    case suffix of
        Just suffixStr ->
            Html.span [ suffixCs ] [ text suffixStr ]

        Nothing ->
            text ""


inputHandler : Config msg -> Maybe (Html.Attribute msg)
inputHandler (Config { onInput }) =
    Maybe.map Html.Events.onInput onInput


focusHandler : Config msg -> Maybe (Html.Attribute msg)
focusHandler (Config { onFocus }) =
    Maybe.map Html.Events.onFocus onFocus


blurHandler : Config msg -> Maybe (Html.Attribute msg)
blurHandler (Config { onBlur }) =
    Maybe.map Html.Events.onBlur onBlur


changeHandler : Config msg -> Maybe (Html.Attribute msg)
changeHandler (Config { onChange }) =
    Maybe.map (\f -> Html.Events.on "change" (Decode.map f Html.Events.targetValue))
        onChange


inputElt : Config msg -> Html msg
inputElt config_ =
    Html.input
        (List.filterMap identity
            [ inputCs
            , typeAttr config_
            , ariaLabelAttr config_
            , placeholderAttr config_
            , inputHandler config_
            , focusHandler config_
            , blurHandler config_
            , changeHandler config_
            , minLengthAttr config_
            , maxLengthAttr config_
            ]
        )
        []


inputCs : Maybe (Html.Attribute msg)
inputCs =
    Just (class "mdc-text-field__input")


patternProp : Config msg -> Maybe (Html.Attribute msg)
patternProp (Config { pattern }) =
    Just
        (Html.Attributes.property "pattern"
            (Maybe.withDefault Encode.null (Maybe.map Encode.string pattern))
        )


typeAttr : Config msg -> Maybe (Html.Attribute msg)
typeAttr (Config { type_ }) =
    Maybe.map Html.Attributes.type_ type_


ariaLabelAttr : Config msg -> Maybe (Html.Attribute msg)
ariaLabelAttr (Config { fullwidth, label }) =
    if fullwidth then
        Maybe.map (Html.Attributes.attribute "aria-label") label

    else
        Nothing


disabledProp : Config msg -> Maybe (Html.Attribute msg)
disabledProp (Config { disabled }) =
    Just (Html.Attributes.property "disabled" (Encode.bool disabled))


labelElt : Config msg -> Html msg
labelElt (Config { label, value, fullwidth }) =
    let
        floatingLabelCs =
            "mdc-floating-label"

        floatingLabelFloatAboveCs =
            "mdc-floating-label--float-above"
    in
    case ( fullwidth, label ) of
        ( False, Just str ) ->
            Html.span
                [ if Maybe.withDefault "" value /= "" then
                    class (floatingLabelCs ++ " " ++ floatingLabelFloatAboveCs)

                  else
                    class floatingLabelCs
                , Html.Attributes.property "foucClassNames"
                    (Encode.list Encode.string [ floatingLabelFloatAboveCs ])
                ]
                [ text str ]

        _ ->
            text ""


noLabelCs : Config msg -> Maybe (Html.Attribute msg)
noLabelCs (Config { label }) =
    if label == Nothing then
        Just (class "mdc-text-field--no-label")

    else
        Nothing


lineRippleElt : Html msg
lineRippleElt =
    Html.span [ class "mdc-line-ripple" ] []


notchedOutlineElt : Config msg -> Html msg
notchedOutlineElt config_ =
    Html.span [ class "mdc-notched-outline" ]
        [ notchedOutlineLeadingElt
        , notchedOutlineNotchElt config_
        , notchedOutlineTrailingElt
        ]


notchedOutlineLeadingElt : Html msg
notchedOutlineLeadingElt =
    Html.span [ class "mdc-notched-outline__leading" ] []


notchedOutlineTrailingElt : Html msg
notchedOutlineTrailingElt =
    Html.span [ class "mdc-notched-outline__trailing" ] []


notchedOutlineNotchElt : Config msg -> Html msg
notchedOutlineNotchElt config_ =
    Html.span [ class "mdc-notched-outline__notch" ] [ labelElt config_ ]
