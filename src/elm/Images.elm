module Images exposing (..)


type Asset
    = Asset String


bikeCuck : Asset
bikeCuck =
    Asset "../../assets/bike_cuck.png"


loss : Asset
loss =
    Asset "../../assets/loss.png"


pettingDog : Asset
pettingDog =
    Asset "../../assets/petting_dog.png"


use : Asset -> String
use (Asset path) =
    path
