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


monkeyHaircut : Asset
monkeyHaircut =
    Asset "../../assets/monkey_haircut.png"


dahlia : Asset
dahlia =
    Asset "../../assets/dahlia.png"


use : Asset -> String
use (Asset path) =
    path
