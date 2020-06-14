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

create table mart.hitrun_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 9),
    primary key (id)
);

create table mart.license_status_lookup (
    id smallint,
    description text not null,
    check (id >= 0 and id <= 9),
    primary key (id)
);

create table mart.dim_vehicle (
    id serial,
    year smallint not null,
    st_case integer not null,
    veh_no integer not null,
    unique (year, st_case, veh_no),
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

create table mart.fact_vehicle (
    crash_vehicle_id integer not null,
    crash_date_id integer not null,
    crash_time_id integer,
    light_condition_id smallint,
    location geography(point, 4326),
    weather_id_1 smallint, -- TODO: rename
    weather_id_2 smallint, -- TODO: rename
    fatalities smallint,
    persons_in_motor_transport smallint,
    driver_distractions integer,
    driver_impairments integer,
    hit_run_id smallint,
    fire_occurred boolean,
    deaths smallint,
    driver_drinking boolean,
    license_status_id smallint,
    foreign key (crash_vehicle_id) references mart.dim_vehicle (id),
    foreign key (crash_date_id) references mart.dim_date (id),
    foreign key (crash_time_id) references mart.dim_time (id),
    foreign key (light_condition_id) references mart.light_condition_lookup (id),
    foreign key (weather_id_1) references mart.weather_lookup (id),
    foreign key (weather_id_2) references mart.weather_lookup (id),
    foreign key (hit_run_id) references mart.hitrun_lookup (id),
    foreign key (license_status_id) references mart.license_status_lookup (id),
    primary key (crash_vehicle_id)
);
