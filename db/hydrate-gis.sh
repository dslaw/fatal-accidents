#!/bin/bash

set -ex

# https://github.com/docker-library/postgres/blob/master/12/docker-entrypoint.sh#L179
function process_sql() {
    psql \
        --username ${POSTGRES_USER} \
        --no-password \
        --dbname ${POSTGRES_DB} \
        --quiet \
        "$@"
}


# Only load 2018 data. Although data for all years (2010-2018) exists,
# the way the 2010 data is packaged is different, and it's not worth
# the effort to write multiple scripts.
mkdir -p /tmp/state-data
cd /tmp/state-data

url="https://www2.census.gov/geo/tiger/TIGER2018/STATE/tl_2018_us_state.zip"
wget --quiet ${url}
unzip *.zip
shp2pgsql -c -G -I *.shp mart.dim_state | process_sql
process_sql <<-EOF
    alter table mart.dim_state add column year smallint;
    update mart.dim_state set year = 2018;
    alter table mart.dim_state alter column year set not null;
    create index state_geom_idx on mart.dim_state using gist (geog);
EOF

cd -
rm -rf /tmp/state-data
