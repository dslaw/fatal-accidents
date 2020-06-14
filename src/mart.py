from pathlib import Path
from typing import List
from uuid import UUID

from src.common import connect


SQL_DIRECTORY = Path("src/sql")


def read_sql(table: str) -> List[str]:
    filestem = f"load-{table}"
    file = (SQL_DIRECTORY / filestem).with_suffix(".sql")
    text = file.read_text()
    stmts = [stmt for stmt in text.split("\n\n") if stmt]
    return stmts


def load_partition(vertical: str, year: int, run_id: UUID) -> None:
    try:
        stmts = read_sql(vertical)
    except FileNotFoundError:
        raise ValueError(f"Unknown vertical: {vertical}")

    conn = connect()
    with conn, conn.cursor() as cursor:
        # SQL script is responsible for ordering the statements
        # correctly.
        for stmt in stmts:
            cursor.execute(stmt, {"year": year, "run_id": run_id})

    return
