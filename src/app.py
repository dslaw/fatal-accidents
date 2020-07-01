from bottle import Bottle, request, response
from rq import Queue
from uuid import UUID
import psycopg2
import redis

from src import load, mart
from src.common import connect, read_params
from src.fetch import fetch_zipfile
from src.tracking import Run


params = read_params()
redis_conn = redis.Redis.from_url(params["queue_url"])
db_conn = connect()
queue = Queue(default_timeout="15m", connection=redis_conn)
app = Bottle()


@app.route("/health", method="GET")
def check_health():
    redis_available = True
    db_available = True

    try:
        redis_conn.ping()
    except redis.exceptions.ConnectionError:
        redis_available = False

    try:
        with db_conn.cursor() as cursor:
            cursor.execute("select 1")
    except psycopg2.OperationalError:
        db_available = False

    if redis_available and db_available:
        return "Available"

    response.status = 503
    return "Unavailable"


@app.route("/runs/<year:int>", method="POST")
def enqueue_partition(year: int):
    skip_cache = request.json.get("skip_cache", False)

    run = Run()
    meta = {"run_id": run.id}
    fetch_job = queue.enqueue(fetch_zipfile, year, skip_cache, meta=meta)
    staging_job = queue.enqueue(
        load.load_partition,
        year,
        run.id,
        depends_on=fetch_job,
        meta=meta
    )
    queue.enqueue(
        mart.load_partition,
        year,
        run.id,
        depends_on=staging_job,
        meta={**meta, "last_job": True}  # type: ignore
    )
    with db_conn:
        run.save(db_conn)

    response.status = 202
    response.set_header("Location", f"/runs/{run.id}/status")
    return {"id": str(run.id)}


@app.route("/runs/<run_id>/status", method="GET")
def get_status(run_id: str):
    try:
        id_ = UUID(run_id)
    except ValueError:
        response.status = 400
        return {"status": "Invalid ID"}

    run = Run.get_by_id(db_conn, id_)

    if run is None:
        response.status = 404
        return {"status": "Not Found"}

    return {"status": run.status}
