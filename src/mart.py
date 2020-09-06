from pathlib import Path
from typing import List
from uuid import UUID

from src.common import connect


SQL_DIRECTORY = Path("src/sql")
SUBTASKS = (
    "load-dim-vehicle",
    "load-dim-person",
    "load-fact-person",
    "load-fact-factor",
)


def read_sql(filestem: str) -> List[str]:
    file = (SQL_DIRECTORY / filestem).with_suffix(".sql")
    text = file.read_text()
    stmts = [stmt for stmt in text.split("\n\n") if stmt]
    return stmts


def load_partition(run_id: UUID) -> None:
    conn = connect()

    with conn, conn.cursor() as cursor:
        for subtask in SUBTASKS:
            stmts = read_sql(subtask)
            for stmt in stmts:
                cursor.execute(stmt, {"run_id": run_id})

    return
