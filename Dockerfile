FROM python:3.8-slim-buster

VOLUME /app/data
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.ini .
COPY src src/

EXPOSE 8000
