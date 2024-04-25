FROM python:3.10-slim

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app

COPY backend /app/backend

COPY manage.py /app/manage.py

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "backend.wsgi:application"]
