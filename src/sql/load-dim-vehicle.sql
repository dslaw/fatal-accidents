-- Upsert a partition for the vehicle dimension.
insert into mart.dim_vehicle (year, st_case, veh_no, driver_drinking, driver_license_status)
select
    etl_year,
    st_case,
    veh_no,
    dr_drink,
    license_status_lookup.description
from staging.vehicles
inner join mart.license_status_lookup on
    vehicles.l_status = license_status_lookup.id
where
    etl_year = %(year)s
    and etl_run_id = %(run_id)s
on conflict (year, st_case, veh_no) do nothing;
