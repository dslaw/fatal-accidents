-- Upsert a partition for the person facts.
create temp table staging as (
    select
        dim_person.id as person_id,
        dim_vehicle.id as vehicle_id,
        dim_date.id as crash_date_id,
        dim_time.id as crash_time_id,
        case
            when accidents.longitud between -180 and 180
                and accidents.latitude between 0 and 90
                then st_setsrid(st_makepoint(accidents.longitud, accidents.latitude), 4326)
            else null
        end as crash_location,
        light_condition_lookup.description as light_condition,
        primary_weather.description as primary_weather,
        secondary_weather.description as secondary_weather,
        case vehicles.hit_run
            when 0 then false
            when 1 then true
            else null
        end as veh_hit_run,
        vehicles.pfire as veh_fire_occurred,
        case persons.age
            when 998 then null
            when 999 then null
            else persons.age
        end as age,
        case persons.sex
            when 1 then 'Male'
            when 2 then 'Female'
            when 8 then null
            when 9 then null
        end as sex,
        case persons.death_da
            when 88 then false
            when 99 then null
            else true
        end as died,
        person_type_lookup.type as person_type,
        person_type_lookup.classification as person_classification,
        person_type_lookup.occupant as occupant,
        -- Mutually exclusive.
        case
            when non_motorists.pedcgp is not null then 'Pedestrian'
            when non_motorists.bikecgp is not null then 'Pedalcyclist'
            else null
        end as non_motorist_type,
        coalesce(
            crash_group_pedestrian_lookup.description,
            crash_group_bicyclist_lookup.description
        ) as non_motorist_crash_group,
        case drinking
            when 0 then false
            when 1 then true
            when 8 then null
            when 9 then null
        end as alcohol_involved,
        -- BAC truncated at .94. (pg 271).
        case
            when alc_res <= .94 then alc_res
            else null
        end as alcohol_test_bac,
        case drugs
            when 0 then false
            when 1 then true
            when 8 then null
            when 9 then null
        end as drugs_involved,
        case pbcwalk
            when 0 then false
            when 1 then true
            else null
        end crosswalk_present,
        case pbswalk
            when 0 then false
            when 1 then true
            else null
        end as sidewalk_present,
        case pbszone
            when 0 then false
            when 1 then true
            else null
        end as in_school_zone
    from staging.persons
    left outer join staging.non_motorists on
        persons.st_case = non_motorists.st_case
        and persons.veh_no = non_motorists.veh_no
        and persons.per_no = non_motorists.per_no
        and persons.etl_run_id = non_motorists.etl_run_id
    inner join mart.dim_person on
        persons.etl_year = dim_person.year
        and persons.st_case = dim_person.st_case
        and persons.veh_no = dim_person.veh_no
        and persons.per_no = dim_person.per_no
    left outer join mart.dim_vehicle on
        persons.st_case = dim_vehicle.st_case
        and persons.veh_no = dim_vehicle.veh_no
    left outer join staging.vehicles on
        persons.st_case = vehicles.st_case
        and persons.veh_no = vehicles.veh_no
        and persons.etl_run_id = vehicles.etl_run_id
    left outer join staging.accidents on
        persons.st_case = accidents.st_case
        and persons.etl_run_id = accidents.etl_run_id
    left outer join mart.dim_date on
        make_date(accidents.year, accidents.month, accidents.day) = dim_date.value
    left outer join mart.dim_time on
        -- Can't use `make_time` due to hour/minute having fill values, which
        -- will throw an error.
        accidents.hour = extract(hour from dim_time.value)
        and accidents.minute = extract(minute from dim_time.value)
    left outer join mart.light_condition_lookup on
        accidents.lgt_cond = light_condition_lookup.id
    left outer join mart.weather_lookup as primary_weather on
        accidents.weather1 = primary_weather.id
    left outer join mart.weather_lookup as secondary_weather on
        accidents.weather2 = secondary_weather.id
    left outer join mart.person_type_lookup on
        persons.per_typ = person_type_lookup.id
    left outer join mart.crash_group_pedestrian_lookup on
        non_motorists.pedcgp = crash_group_pedestrian_lookup.id
    left outer join mart.crash_group_bicyclist_lookup on
        non_motorists.bikecgp = crash_group_bicyclist_lookup.id
    where persons.etl_run_id = %(run_id)s
);

delete from mart.fact_person as target
using staging
where target.person_id = staging.person_id;

insert into mart.fact_person (
    person_id,
    vehicle_id,
    crash_date_id,
    crash_time_id,
    crash_location,
    light_condition,
    primary_weather,
    secondary_weather,
    veh_hit_run,
    veh_fire_occurred,
    age,
    sex,
    died,
    person_type,
    person_type_classification,
    occupant,
    non_motorist_type,
    non_motorist_crash_group,
    alcohol_involved,
    alcohol_test_bac,
    drugs_involved,
    crosswalk_present,
    sidewalk_present,
    in_school_zone
)
table staging;

drop table staging;
