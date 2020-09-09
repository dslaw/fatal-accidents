from psycopg2.extras import register_uuid
from time import sleep, time
from typing import Any, ContextManager, Dict
import os
import psycopg2


class Connectable(ContextManager):
    autocommit: bool

    def cursor(self, *args, **kwargs) -> psycopg2.extensions.cursor:
        ...

    def set_session(self, *args, **kwargs) -> None:
        ...


def read_params() -> Dict[str, Any]:
    params = {
        "database_url": os.environ["DATABASE_URL"],
        "queue_url": os.environ["QUEUE_URL"],
        "cache_dir": os.environ["CACHE_DIR"],
    }
    return params


def connect(max_wait_time: int = 60 * 5) -> Connectable:
    if max_wait_time < 0:
        raise ValueError("`max_wait_time` must be non-negative")

    params = read_params()
    error_message = ""
    end_t = time() + max_wait_time
    while time() < end_t:
        try:
            conn: Connectable = psycopg2.connect(params["database_url"])
            register_uuid()
            return conn
        except psycopg2.OperationalError as e:
            error_message = str(e)
            sleep(1)

    raise psycopg2.OperationalError(error_message)
