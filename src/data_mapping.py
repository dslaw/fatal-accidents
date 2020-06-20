tables = {
    "accident": "accidents",
    "distract": "distractions",
    "drimpair": "impairments",
    "vehicle": "vehicles",
    "person": "persons",
    "pbtype": "non_motorists",  # From 2014.
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
        "dr_drink",
        "l_status",
    ],
    "persons": [
        "st_case",
        "veh_no",
        "per_no",
        "age",
        "sex",
        "per_typ",
        "drinking",
        "alc_res",
        "drugs",
        "death_da",
    ],
    "non_motorists": [
        "st_case",
        "veh_no",
        "per_no",
        "pbcwalk",
        "pbswalk",
        "pbszone",
        "pedcgp",
        "bikecgp",
    ],
}
