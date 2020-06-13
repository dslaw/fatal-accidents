from pkgutil import get_data
from typing import Any, ContextManager, Dict
import psycopg2
import yaml


class Connectable(ContextManager):
    def cursor(self, *args, **kwargs) -> psycopg2.extensions.cursor:
        ...

    def set_session(self, *args, **kwargs) -> None:
        ...


def read_params() -> Dict[str, Any]:
    data = get_data("src", "resources/params.yml")
    if data is None:
        raise FileNotFoundError("Package parameters file not found")
    params: Dict[str, Any] = yaml.load(data, Loader=yaml.BaseLoader)
    return params


def connect() -> Connectable:
    params = read_params()
    conn: Connectable = psycopg2.connect(**params["database"])
    conn.set_session(isolation_level=psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ)
    return conn
