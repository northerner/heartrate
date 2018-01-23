import Html exposing (..)
import Html.Events exposing (..)
import Keyboard
import Char
import Task
import Time exposing (..)

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL

type alias Model =
  { heartrate : Float
  , lastBeat : Float
  }

init : (Model, Cmd Msg)
init =
  ({ heartrate = 0, lastBeat = 0 }, Cmd.none)

-- UPDATE

type Msg
  = Add
  | OnTime Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add ->
      (model, getTime)
    OnTime time ->
      (
        { heartrate = (calcHeartrate model.lastBeat time )
        , lastBeat = inSeconds time }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Keyboard.presses (\code -> Add)

calcHeartrate : Time -> Time -> Float
calcHeartrate previousTime currentTime =
  60 / ((inSeconds currentTime) - previousTime)

-- TASKS

getTime : Cmd Msg
getTime =
  Task.perform OnTime Time.now

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "Check your pulse" ]
    , p [] [ text "Press any key or click below on each pulse to calculate heartrate" ]
    , button [ onClick Add ] [ text "Add beat" ]
    , h1 [] [ text (toString (round model.heartrate)) ]
    ]
