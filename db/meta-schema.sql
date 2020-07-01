create schema "meta";

create table meta.runs (
    id uuid,
    status text not null,
    started_at timestamp without time zone not null,
    finished_at timestamp without time zone,
    primary key (id)
);
