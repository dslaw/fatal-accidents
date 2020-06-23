create temp table staging as (select * from mart.fact_factor limit 0);
with merged as (
    -- 0 is a universal indicator for known N/A. Filter them
    -- and let lack of existence indicate... lack of existence.
    select
        etl_run_id,
        etl_year,
        st_case,
        veh_no,
        null::smallint as per_no,
        'Driver Distraction' as type,
        distractions_lookup.description as crash_factor
    from staging.distractions
    inner join mart.distractions_lookup on
        distractions.mdrdstrd = distractions_lookup.id
    where distractions.mdrdstrd <> 0
    union all
    select
        etl_run_id,
        etl_year,
        st_case,
        veh_no,
        null::smallint as per_no,
        'Driver Impairment' as type,
        impairment_lookup.description as crash_factor
    from staging.impairments
    inner join mart.impairment_lookup on
        impairments.drimpair = impairment_lookup.id
    where impairments.drimpair <> 0
    union all
    select
        etl_run_id,
        etl_year,
        st_case,
        veh_no,
        null::smallint as per_no,
        'Vehicle Factor' as type,
        veh_factors_lookup.description as crash_factor
    from staging.veh_factors
    inner join mart.veh_factors_lookup on
        veh_factors.mfactor = veh_factors_lookup.id
    where veh_factors.mfactor <> 0
    union all
    select
        etl_run_id,
        etl_year,
        st_case,
        veh_no,
        null::smallint as per_no,
        'Driver Visual Obstruction' as type,
        visual_obstructions_lookup.description as crash_factor
    from staging.visual_obstructions
    inner join mart.visual_obstructions_lookup on
         visual_obstructions.mvisobsc = visual_obstructions_lookup.id
    where visual_obstructions.mvisobsc <> 0
    union all
    select
        etl_run_id,
        etl_year,
        st_case,
        veh_no,
        per_no,
        'Non-Motorist Impairment' as type,
        nm_impairments_lookup.description as crash_factor
    from staging.nm_impairments
    inner join mart.nm_impairments_lookup on
         nm_impairments.nmimpair = nm_impairments_lookup.id
    where nm_impairments.nmimpair <> 0
)
insert into staging
select
    dim_vehicle.id as vehicle_id,
    dim_person.id as person_id,
    merged.type,
    case
        when merged.crash_factor like 'Unknown%%' then 'Unknown'
        else merged.crash_factor
    end as crash_factor
from merged
left outer join mart.dim_vehicle on
    merged.etl_year = dim_vehicle.year
    and merged.st_case = dim_vehicle.st_case
    and merged.veh_no = dim_vehicle.veh_no
left outer join mart.dim_person on
    merged.etl_year = dim_person.year
    and merged.st_case = dim_person.st_case
    and merged.veh_no = dim_person.veh_no
    and merged.per_no = dim_person.per_no
where
    merged.etl_year = %(year)s
    and merged.etl_run_id = %(run_id)s
    -- Not all factors are connected to a vehicle or person, although they
    -- logically have to be. As vehicle and person are the grains under
    -- consideration, we filter these "entity-less" records out, although
    -- they can be traced back to an accident.
    and (dim_vehicle.id is not null or dim_person.id is not null);

delete from mart.fact_factor as target
using staging
where
    coalesce(target.vehicle_id, -1) = coalesce(staging.vehicle_id, -1)
    and coalesce(target.person_id, -1) = coalesce(staging.person_id, -1);

insert into mart.fact_factor (vehicle_id, person_id, type, crash_factor)
table staging;

drop table staging;
