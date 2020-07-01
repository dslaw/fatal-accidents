from datetime import datetime
from rq.worker import SimpleWorker
from typing import Optional
from uuid import UUID, uuid4

from src.common import Connectable, connect


class Run:
    def __init__(self, id_: Optional[UUID] = None):
        self.id: UUID = id_ or uuid4()
        self.status: str = "Active"
        self.started_at: Optional[datetime] = datetime.utcnow()
        self.finished_at: Optional[datetime] = None

    @classmethod
    def get_by_id(cls, conn: Connectable, id_: UUID):
        with conn.cursor() as cursor:
            cursor.execute(
                """
                select
                    status,
                    started_at,
                    finished_at
                from meta.runs
                where id = %(run_id)s
                """,
                {"run_id": id_}
            )
            record = cursor.fetchone()

        if not record:
            return None

        run = cls(id_)
        run.status = record[0]
        run.started_at = record[1]
        run.finished_at = record[2]
        return run

    def save(self, conn: Connectable):
        with conn.cursor() as cursor:
            cursor.execute(
                """
                insert into meta.runs (id, status, started_at, finished_at)
                values (%(id)s, %(status)s, %(started_at)s, %(finished_at)s)
                on conflict (id) do update set
                    status = excluded.status,
                    finished_at = excluded.finished_at
                """,
                {
                    "id": self.id,
                    "status": self.status,
                    "started_at": self.started_at,
                    "finished_at": self.finished_at,
                }
            )
        return self


class TrackingWorker(SimpleWorker):
    @property
    def conn(self):
        if not hasattr(self, "_conn"):
            self._conn = connect()
        return self._conn

    def perform_job(self, job, queue, heartbeat_ttl=None):
        run_id = job.meta["run_id"]
        run = Run(run_id)
        last_job = job.meta.get("last_job", False)

        successful = super().perform_job(job, queue, heartbeat_ttl=heartbeat_ttl)
        if (successful and last_job) or not successful:
            run.status = "Successful" if successful else "Failed"
            run.finished_at = datetime.utcnow()
            with self.conn:
                run.save(self.conn)

        return successful
