from bottle import Bottle, request, response
from rq import Queue
from uuid import uuid4
import redis

from src import load, mart
from src.common import read_params
from src.fetch import fetch_zipfile


params = read_params()
redis_conn = redis.Redis(**params["redis"])
queue = Queue(default_timeout="15m", connection=redis_conn)
app = Bottle()


@app.route("/health", method="GET")
def check_health():
    def respond_negative() -> str:
        response.status = 503
        return "Unavailable"

    try:
        redis_available = redis_conn.ping()
    except redis.exceptions.ConnectionError:
        return respond_negative()

    if not redis_available:
        return respond_negative()

    return "Available"


@app.route("/runs/<year:int>", method="POST")
def enqueue_partition(year: int):
    skip_cache = request.json.get("skip_cache", False)

    run_id = uuid4()

    fetch_job = queue.enqueue(fetch_zipfile, year, skip_cache)
    staging_job = queue.enqueue(load.load_partition, year, run_id, depends_on=fetch_job)
    queue.enqueue(mart.load_partition, "vehicle", year, run_id, depends_on=staging_job)

    response.status = 202
    return {"id": str(run_id)}
