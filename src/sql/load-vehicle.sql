-- Upsert a partition for the vehicle dimension.
insert into mart.dim_vehicle (year, st_case, veh_no)
select
    etl_year,
    st_case,
    veh_no
from staging.vehicles
where
    etl_run_id = %(run_id)s
    and etl_year = %(year)s
on conflict (year, st_case, veh_no) do nothing;

-- Upsert a partition for the vehicle facts.
with distractions as (
    select
        st_case,
        veh_no,
        etl_year,
        count(*)
    from staging.distractions
    where mdrdstrd not in (0, 96, 99)
    group by
        st_case,
        veh_no,
        etl_year
),
impairments as (
    select
        st_case,
        veh_no,
        etl_year,
        count(*)
    from staging.impairments
    where drimpair not in (0, 95, 98, 99)
    group by
        st_case,
        veh_no,
        etl_year
),
staged as (
    select
        dim_vehicle.id as crash_vehicle_id,
        dim_date.id,
        dim_time.id,
        accidents.lgt_cond,
        case
            when longitud between -180 and 180
                and latitude between 0 and 90
                then st_setsrid(st_makepoint(longitud, latitude), 4326)
            else null
        end,
        accidents.weather1,
        accidents.weather2,
        accidents.fatals,
        accidents.permvit,
        coalesce(distractions.count, 0),
        coalesce(impairments.count, 0),
        vehicles.hit_run,
        vehicles.fire_exp,
        vehicles.deaths,
        vehicles.dr_drink,
        vehicles.l_status
    from staging.vehicles
    inner join mart.dim_vehicle on
        vehicles.etl_year = dim_vehicle.year
        and vehicles.st_case = dim_vehicle.st_case
        and vehicles.veh_no = dim_vehicle.veh_no
    inner join staging.accidents on
        vehicles.st_case = accidents.st_case
        and vehicles.etl_year = accidents.etl_year
    left outer join mart.dim_date on
        make_date(accidents.year, accidents.month, accidents.day) = dim_date.value
    left outer join mart.dim_time on
        -- Can't use `make_time` due to hour/minute having fill values, which
        -- will throw an error.
        accidents.hour = extract(hour from dim_time.value)
        and accidents.minute = extract(minute from dim_time.value)
    left outer join distractions on
        vehicles.st_case = distractions.st_case
        and vehicles.veh_no = distractions.veh_no
        and vehicles.etl_year = distractions.etl_year
    left outer join impairments on
        vehicles.st_case = impairments.st_case
        and vehicles.veh_no = impairments.veh_no
        and vehicles.etl_year = impairments.etl_year
    where
        vehicles.etl_run_id = %(run_id)s
        and vehicles.etl_year = %(year)s
),
deleted as (
    delete from mart.fact_vehicle as target
    using staged
    where target.crash_vehicle_id = staged.crash_vehicle_id
)
insert into mart.fact_vehicle (
    crash_vehicle_id,
    crash_date_id,
    crash_time_id,
    light_condition_id,
    location,
    weather_id_1,
    weather_id_2,
    fatalities,
    persons_in_motor_transport,
    driver_distractions,
    driver_impairments,
    hit_run_id,
    fire_occurred,
    deaths,
    driver_drinking,
    license_status_id
)
table staged
on conflict (crash_vehicle_id) do nothing;
