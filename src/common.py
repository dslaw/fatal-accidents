from psycopg2.extras import register_uuid
from typing import Any, ContextManager, Dict
import os
import psycopg2


class Connectable(ContextManager):
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


def connect() -> Connectable:
    params = read_params()
    conn: Connectable = psycopg2.connect(params["database_url"])
    conn.set_session(isolation_level=psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ)
    register_uuid()
    return conn
