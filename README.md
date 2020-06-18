# fatal-accidents

[![Build Status](https://travis-ci.org/dslaw/fatal-accidents.svg?branch=master)](https://travis-ci.org/dslaw/fatal-accidents)

Example of event-driven ELT using the
[FARS](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)
(USA fatal traffic accidents) data.


## Development

To get started, first create an environment file with the database connection
variables `POSTGRES_DB`, `POSTGRES_USER` and `POSTGRES_PASSWORD` defined.

Then, use `docker-compose` to run the stack locally:

```bash
docker-compose --env-file=.env up -d
```

Trigger a run:

```bash
curl -X POST \
    http://localhost:8000/runs/2010 \
    --header 'Content-Type: application/json' \
    --data '{"skip_cache": false}'
```

When the run has completed, you can connect to the Postgres database
(at localhost:8002) using the credentials defined earlier and look at the data.


To setup a local development environment:

```bash
virtualenv .venv --python=$(which python3.8)
source .venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
```
