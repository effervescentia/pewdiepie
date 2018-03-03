module Images exposing (..)


type Asset
    = Asset String


bikeCuck : Asset
bikeCuck =
    Asset "../../assets/bike_cuck.png"


use : Asset -> String
use (Asset path) =
    path
