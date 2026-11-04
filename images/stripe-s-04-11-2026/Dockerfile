FROM python:3.12-slim
WORKDIR /app
COPY server/python/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt gunicorn==23.0.0
COPY server/python/server.py server.py
COPY client/html /app/client
ENV STATIC_DIR=/app/client
ENV PYTHONUNBUFFERED=1
EXPOSE 4242
CMD ["gunicorn", "--bind", "0.0.0.0:4242", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "server:app"]
