tables = {
    "accident": "accidents",
    "distract": "distractions",
    "drimpair": "impairments",
    "vehicle": "vehicles",
}

table_columns = {
    "accidents": [
        "st_case",
        "year",
        "month",
        "day",
        "hour",
        "minute",
        "latitude",
        "longitud",
        "lgt_cond",
        "weather1",
        "weather2",
        "fatals",
        "permvit",
    ],
    "distractions": [
        "st_case",
        "veh_no",
        "mdrdstrd",
    ],
    "impairments": [
        "st_case",
        "veh_no",
        "drimpair",
    ],
    "vehicles": [
        "st_case",
        "veh_no",
        "hit_run",
        "pfire",
        "deaths",
        "dr_drink",
        "l_status",
    ],
}
