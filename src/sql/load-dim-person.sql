-- Upsert a partition for the person dimension.
-- `non_motorists` is a subset of `persons` with additional information.
insert into mart.dim_person (year, st_case, veh_no, per_no)
select
    etl_year,
    st_case,
    veh_no,
    per_no
from staging.persons
where
    etl_year = %(year)s
    and etl_run_id = %(run_id)s
on conflict (year, st_case, veh_no, per_no) do nothing;
