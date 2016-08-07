module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date as Date
import String exposing (toInt)
import Result exposing (withDefault)


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { xp : Int
    , startingDay : Date.Date
    , today : Date.Date
    }


init : ( Model, Cmd Msg )
init =
    ( Model 0 (Date.fromTime 0) (Date.fromTime 0), Cmd.none )



-- UPDATE


type Msg
    = UpdateXP String
    | UpdateDay String
    | UpdateMonth String
    | UpdateYear String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        start =
            model.startingDay

        newDate =
            updateDate start msg
    in
        case msg of
            UpdateXP newXP ->
                ( { model | xp = parseInput newXP }, Cmd.none )

            _ ->
                ( { model | startingDay = updateDate start msg }, Cmd.none )


updateDate : Date.Date -> Msg -> Date.Date
updateDate start msg =
    let
        day =
            Date.day start |> toString

        month =
            Date.month start |> toString

        year =
            Date.year start |> toString
    in
        case msg of
            UpdateDay newDay ->
                month ++ "." ++ newDay ++ "." ++ year |> Date.fromString |> withDefault start

            UpdateMonth newMonth ->
                newMonth ++ "." ++ day ++ "." ++ year |> Date.fromString |> withDefault start

            UpdateYear newYear ->
                month ++ "." ++ day ++ "." ++ newYear |> Date.fromString |> withDefault start

            -- interesting... You can create a problem for yourself if you "split" a case/of statement by passing the operator in the default branch... might want to look into this
            _ ->
                start


parseInput : String -> Int
parseInput input =
    withDefault 0 (toInt input)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "When will I reach the next level?" ]
        , h3 [] [ text "Enter your numbers!" ]
        , inputBoxes model
        , h3 [] [ text "Here are your results:" ]
        , results model
        ]


inputBoxes : Model -> Html Msg
inputBoxes model =
    div []
        [ input [ placeholder "XP", onInput UpdateXP ] []
        , input [ placeholder "Day", onInput UpdateDay ] []
        , input [ placeholder "Month", onInput UpdateMonth ] []
        , input [ placeholder "Year", onInput UpdateYear ] []
        ]


results : Model -> Html Msg
results model =
    let
        start =
            model.startingDay
    in
        div [] []
