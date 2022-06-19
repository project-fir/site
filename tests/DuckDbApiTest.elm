module DuckDbApiTest exposing (..)

import Array as A
import Array2D exposing (..)
import DuckDbApi exposing (Val(..), duckDbQueryResponseDecoder)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as JD
import Test exposing (..)


suite : Test
suite =
    describe "Module for communicating with DuckDB endpoints for this site's API"
        [ describe "JSON decoding"
            [ test "Conditionally parse columns based on value in 'type' field"
                (\_ ->
                    response
                        |> JD.decodeString duckDbQueryResponseDecoder
                        |> Expect.equal
                            (Ok
                                { columns =
                                    [ { name = "candidate_name"
                                      , type_ = "VARCHAR"
                                      , vals =
                                            [ Varchar_ "George Washington"
                                            , Varchar_ "Thomas Jefferson"
                                            , Varchar_ "Benjamin Franklin"
                                            ]
                                      }
                                    , { name = "year_of_birth"
                                      , type_ = "INTEGER"
                                      , vals =
                                            [ Int_ 1732
                                            , Int_ 1743
                                            , Int_ 1706
                                            ]
                                      }
                                    ]
                                }
                            )
                )
            ]
        ]


response =
    """
{
    "columns": [
        {
            "name": "candidate_name",
            "type": "VARCHAR",
            "values": ["George Washington", "Thomas Jefferson", "Benjamin Franklin"]
        },
        {
            "name": "year_of_birth",
            "type": "INTEGER",
            "values": [1732, 1743, 1706]
        }
    ]
}
"""
