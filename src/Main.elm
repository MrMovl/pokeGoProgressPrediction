module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Date)
import String exposing (toInt)
import Result exposing (withDefault)
import Levels exposing (..)
import Time exposing (Time)
import Task


main : Program Never Model Msg
main =
    Html.program
        { init = initialize
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


epoch : Date
epoch =
    Date.fromTime 0


initialize : ( Model, Cmd Msg )
initialize =
    ( Model 709627 epoch epoch, Task.perform Today Time.now )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { xp : Float
    , startingDay : Date
    , today : Date
    }



-- UPDATE


type Msg
    = UpdateXP String
    | UpdateDay String
    | UpdateMonth String
    | UpdateYear String
    | Today Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        start =
            model.startingDay

        newDate =
            updateDate start msg
    in
        case msg of
            Today currentTime ->
                ( { model | today = Date.fromTime currentTime }, Cmd.none )

            UpdateXP newXP ->
                ( { model | xp = parseInput newXP }, Cmd.none )

            _ ->
                ( { model | startingDay = updateDate start msg }, Cmd.none )


updateDate : Date -> Msg -> Date
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
                updateDay newDay start

            UpdateMonth newMonth ->
                updateMonth newMonth start

            UpdateYear newYear ->
                updateYear newYear start

            _ ->
                start


datify_ : Date -> String -> Date
datify_ fallback dateString =
    dateString |> Date.fromString |> withDefault fallback


datify : String -> Date
datify =
    datify_ epoch


updateDay : String -> Date -> Date
updateDay newDay date =
    let
        ( day, month, year ) =
            splitDate date
    in
        month ++ "." ++ newDay ++ "." ++ year |> datify


updateMonth : String -> Date -> Date
updateMonth newMonth date =
    let
        ( day, month, year ) =
            splitDate date
    in
        newMonth ++ "." ++ day ++ "." ++ year |> datify


updateYear : String -> Date -> Date
updateYear newYear date =
    let
        ( day, month, year ) =
            splitDate date
    in
        month ++ "." ++ day ++ "." ++ newYear |> datify


splitDate : Date -> ( String, String, String )
splitDate date =
    ( Date.day date |> toString, Date.month date |> toString, Date.year date |> toString )


parseInput : String -> Float
parseInput input =
    withDefault 0 (toInt input) |> toFloat



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
        [ input [ placeholder "XP", onInput UpdateXP ] [ model.xp |> toString |> text ]
        , input [ placeholder "Day", onInput UpdateDay ] [ model.startingDay |> Date.day |> toString |> text ]
        , input [ placeholder "Month", onInput UpdateMonth ] [ model.startingDay |> Date.month |> toString |> text ]
        , input [ placeholder "Year", onInput UpdateYear ] [ model.startingDay |> Date.year |> toString |> text ]
        ]


results : Model -> Html Msg
results { xp, today, startingDay } =
    let
        todayAsTime =
            Date.toTime today

        diff =
            todayAsTime - (Date.toTime startingDay)

        milisecondsPerXP =
            diff / xp

        remainingLevels =
            getRemainingLevels xp
    in
        div []
            [ div [] [ xp |> getNextPlayerLevel |> levelDisplay ]
            , ul [] (createLevelRows milisecondsPerXP todayAsTime remainingLevels)
            ]


getRemainingLevels : Float -> List Level
getRemainingLevels xp =
    List.filter (\level -> level.threshold > xp) levels


getNextPlayerLevel : Float -> Maybe Level
getNextPlayerLevel xp =
    xp |> getRemainingLevels |> List.head


levelDisplay : Maybe Level -> Html Msg
levelDisplay level =
    case level of
        Just playerLevel ->
            (playerLevel.level - 1) |> toString |> (++) "Your current Level is " |> text

        Nothing ->
            "XP don't match any Level" |> text


createLevelRows : Float -> Time -> List Level -> List (Html Msg)
createLevelRows milisecondsPerXP today remainingLevels =
    let
        datesAndLevels =
            extrapolate today milisecondsPerXP remainingLevels
    in
        List.map createSingleRow datesAndLevels


createSingleRow : ( Float, Int ) -> Html Msg
createSingleRow ( date, level ) =
    li []
        [ date
            |> Date.fromTime
            |> prettyDate
            |> (++) ("Level " ++ (toString level) ++ ": ")
            |> text
        ]


extrapolate : Time -> Float -> List Level -> List ( Float, Int )
extrapolate today milisecondsPerXP remainingLevels =
    List.map (\level -> ( today + level.threshold * milisecondsPerXP, level.level )) remainingLevels


prettyDate : Date -> String
prettyDate date =
    if (date |> Date.day |> toString) == "NaN" then
        "Way too long"
    else
        (toString (Date.day date)) ++ ". " ++ (toString (Date.month date)) ++ " " ++ (toString (Date.year date))
