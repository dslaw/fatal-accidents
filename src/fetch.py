"""Download FARS datasets."""

from pathlib import Path
from shutil import copyfileobj
from typing import Dict
import json
import requests

from src.common import read_params


params = read_params()
STAGING_DIR = Path(params["cache_dir"])
URLS_FILE = Path("src/resources/dataset_urls.json")


# URLs to zipped csv files for national FARS data.
with URLS_FILE.open("r") as fh:
    _dataset_paths = json.load(fh)  # type: ignore

LINKS: Dict[int, str] = {
    int(year): path[-1]["href"]
    for year, path in _dataset_paths.items()
    if int(year) >= 2010
}


def make_zipfile(year: int) -> Path:
    return (STAGING_DIR / str(year)).with_suffix(".zip")


def fetch_zipfile(year: int, skip_cache: bool) -> None:
    try:
        url = LINKS[year]
    except KeyError:
        raise ValueError(f"{year} not found")

    output_file = make_zipfile(year)

    if not skip_cache and output_file.exists():
        return

    # Based on: https://stackoverflow.com/a/39217788
    with requests.get(url, stream=True, timeout=60) as response:
        with output_file.open("wb") as output_fh:
            copyfileobj(response.raw, output_fh)

    return
