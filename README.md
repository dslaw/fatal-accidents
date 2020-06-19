# fatal-accidents

Example of event-driven ELT using the
[FARS](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)
(USA fatal traffic accidents) data.


## Development

To setup a local development environment:

```bash
virtualenv .venv --python=$(which python3.8)
source .venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
```
