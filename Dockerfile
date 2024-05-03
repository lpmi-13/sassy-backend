FROM python:3.10-slim

ARG USER=django
ARG USER_ID=1000
ARG GROUP_ID=$USER_ID

RUN groupadd -g $GROUP_ID $USER \
    && useradd -u $USER_ID -g $GROUP_ID $USER -M

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app

COPY backend /app/backend

COPY manage.py /app/manage.py

EXPOSE 8000

USER django

# be aware that this will swallow exceptions and hide any blowups, so the pod won't
# restart on errors
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "backend.wsgi:application"]
