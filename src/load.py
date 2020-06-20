"""Load to staging."""

from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
from psycopg2 import sql
from typing import Dict, Iterable, List, NamedTuple, Tuple
from uuid import UUID
from zipfile import ZipFile
import csv

from src import data_mapping
from src.common import Connectable, connect
from src.fetch import make_zipfile


Record = Dict[str, str]


class Metadata(NamedTuple):
    etl_run_id: UUID
    etl_year: int
    etl_loaded_at: datetime

    @classmethod
    def create(cls, run_id: UUID, year: int) -> "Metadata":
        loaded_at = datetime.utcnow().astimezone(timezone.utc)
        return cls(run_id, year, loaded_at)


STAGING_SCHEMA = "staging"


def read_data(table: str, year: int) -> str:
    input_file = make_zipfile(year)
    file = Path(table).with_suffix(".csv")

    with ZipFile(input_file, "r") as zf:
        filename = str(file).upper()
        data = zf.read(filename)

    return data.decode()


def deserialize(data: str) -> Iterable[Record]:
    with StringIO(data) as buffer:
        reader = csv.DictReader(buffer)
        for record in reader:
            yield record

    return


def make_row(record: Record, columns: List[str], metadata: Metadata) -> Tuple:
    row = tuple(record.get(column) for column in columns)
    return row + metadata


def delete_partition(conn: Connectable, dst_table: sql.Identifier, year: int) -> None:
    stmt = sql.SQL("delete from {} where etl_year = %(year)s").format(dst_table)
    with conn.cursor() as cursor:
        cursor.execute(stmt, {"year": year})
    return


def load_table_partition(conn: Connectable, table: str, year: int, run_id: UUID) -> None:
    try:
        dst_table = data_mapping.tables[table]
    except KeyError:
        raise ValueError(f"Unknown table: {table}")

    qualified_table = sql.Identifier(STAGING_SCHEMA, dst_table)
    metadata = Metadata.create(run_id, year)

    try:
        data = read_data(table, year)
    except KeyError:
        # Table is registered as known, but doesn't exist for
        # this year.
        return

    # Prepare data for bulk load.
    records = deserialize(data)
    columns = data_mapping.table_columns[dst_table]
    cased_columns = [column.upper() for column in columns]
    rows = map(lambda record: make_row(record, cased_columns, metadata), records)
    dst_columns = columns + list(metadata._fields)

    delimiter = ","
    buffer = StringIO()
    writer = csv.writer(buffer, delimiter=delimiter)
    writer.writerows(rows)
    buffer.seek(0)

    # Insert or replace partition.
    with conn, conn.cursor() as cursor:
        delete_partition(conn, qualified_table, year)
        cursor.copy_from(
            buffer,
            qualified_table.as_string(conn),
            sep=delimiter,
            null="",
            columns=dst_columns
        )

    return


def load_partition(year: int, run_id: UUID) -> None:
    conn = connect()

    # XXX: Not atomic - tables may have mixed failure/success.
    for table in data_mapping.tables:
        load_table_partition(conn, table, year, run_id)

    return
