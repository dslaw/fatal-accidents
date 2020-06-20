create schema "staging";

create table staging.accidents (
    id serial not null,
    st_case integer,
    year smallint,
    month smallint,
    day smallint,
    hour smallint,
    minute smallint,
    latitude double precision,
    longitud double precision,
    lgt_cond smallint,
    weather1 smallint,
    weather2 smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);

create table staging.distractions (
    id serial not null,
    st_case integer,
    veh_no smallint,
    mdrdstrd smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);

create table staging.impairments (
    id serial not null,
    st_case integer,
    veh_no smallint,
    drimpair smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);

create table staging.vehicles (
    id serial not null,
    st_case integer,
    veh_no smallint,
    hit_run smallint,
    pfire boolean,
    dr_drink boolean,
    l_status smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);

create table staging.persons (
    id serial not null,
    st_case integer,
    veh_no smallint,
    per_no smallint,
    age smallint,
    sex smallint,
    per_typ smallint,
    drinking smallint,
    alc_res smallint,
    drugs smallint,
    death_da smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);

create table staging.non_motorists (
    id serial not null,
    st_case integer,
    veh_no smallint,
    per_no smallint,
    pbcwalk smallint,
    pbswalk smallint,
    pbszone smallint,
    pedcgp smallint,
    bikecgp smallint,
    etl_run_id uuid not null,
    etl_year smallint not null,
    etl_loaded_at timestamp without time zone not null
);
