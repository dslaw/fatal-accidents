create schema "mart";

create table mart.light_condition_lookup (
    id smallint,
    description text,
    check (id >= 1 and id <= 9),
    primary key (id)
);

create table mart.weather_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.license_status_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 9),
    primary key (id)
);

create table mart.person_type_lookup (
    id smallint,
    type text not null,
    classification text not null,
    occupant boolean,
    check (id >= 0 and id <= 88),
    primary key (id)
);

create table mart.crash_group_pedestrian_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 990),
    primary key (id)
);

create table mart.crash_group_bicyclist_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 990),
    primary key (id)
);

create table mart.impairment_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.distractions_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.veh_factors_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.visual_obstructions_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.nm_impairments_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 99),
    primary key (id)
);

create table mart.dim_date (
    id serial,
    value date not null,
    unique (value),
    primary key (id)
);

create table mart.dim_time (
    id serial,
    value time without time zone not null,
    unique (value),
    primary key (id)
);

create table mart.dim_vehicle (
    id serial,
    year smallint not null,
    st_case integer not null,
    veh_no integer not null,
    driver_drinking boolean not null,
    driver_license_status text not null,
    unique (year, st_case, veh_no),
    primary key (id)
);

create table mart.dim_person (
    id serial,
    year smallint not null,
    st_case integer not null,
    veh_no integer not null,
    per_no integer not null,
    unique (year, st_case, veh_no, per_no),
    primary key (id)
);

create table mart.fact_person (
    person_id integer not null,
    vehicle_id integer,
    crash_date_id integer not null,
    crash_time_id integer,
    crash_location geography(point, 4326),
    light_condition text,
    primary_weather text,
    secondary_weather text,
    veh_hit_run boolean,
    veh_fire_occurred boolean,
    age integer,
    sex text,
    died boolean,
    person_type text,
    person_type_classification text,
    occupant boolean,
    non_motorist_type text,
    non_motorist_crash_group text,
    alcohol_involved boolean,
    alcohol_test_bac integer,
    drugs_involved boolean,
    crosswalk_present boolean,
    sidewalk_present boolean,
    in_school_zone boolean,
    foreign key (person_id) references mart.dim_person (id),
    foreign key (vehicle_id) references mart.dim_vehicle (id),
    foreign key (crash_date_id) references mart.dim_date (id),
    foreign key (crash_time_id) references mart.dim_time (id),
    primary key (person_id)
);

-- Factors related to a vehicle's crash.
create table mart.fact_factor (
    vehicle_id integer,
    person_id integer,
    type text not null,
    crash_factor text not null,
    foreign key (vehicle_id) references mart.dim_vehicle (id),
    foreign key (person_id) references mart.dim_person (id)
);
