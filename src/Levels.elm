module Levels exposing (..)


type alias Level =
    { level : Int
    , threshold : Int
    }


levels : List Level
levels =
    [ { level = 1, threshold = 0 }
    , { level = 2, threshold = 1000 }
    , { level = 3, threshold = 3000 }
    , { level = 4, threshold = 6000 }
    , { level = 5, threshold = 10000 }
    , { level = 6, threshold = 15000 }
    , { level = 7, threshold = 21000 }
    , { level = 8, threshold = 28000 }
    , { level = 9, threshold = 36000 }
    , { level = 10, threshold = 45000 }
    , { level = 11, threshold = 55000 }
    , { level = 12, threshold = 65000 }
    , { level = 13, threshold = 75000 }
    , { level = 14, threshold = 85000 }
    , { level = 15, threshold = 100000 }
    , { level = 16, threshold = 120000 }
    , { level = 17, threshold = 140000 }
    , { level = 18, threshold = 160000 }
    , { level = 19, threshold = 185000 }
    , { level = 20, threshold = 210000 }
    , { level = 21, threshold = 260000 }
    , { level = 22, threshold = 335000 }
    , { level = 23, threshold = 435000 }
    , { level = 24, threshold = 560000 }
    , { level = 25, threshold = 710000 }
    , { level = 26, threshold = 900000 }
    , { level = 27, threshold = 1100000 }
    , { level = 28, threshold = 1350000 }
    , { level = 29, threshold = 1650000 }
    , { level = 30, threshold = 2000000 }
    , { level = 31, threshold = 2500000 }
    , { level = 32, threshold = 3000000 }
    , { level = 33, threshold = 3750000 }
    , { level = 34, threshold = 4750000 }
    , { level = 35, threshold = 6000000 }
    , { level = 36, threshold = 7500000 }
    , { level = 37, threshold = 9500000 }
    , { level = 38, threshold = 12000000 }
    , { level = 39, threshold = 15000000 }
    , { level = 40, threshold = 20000000 }
    ]
