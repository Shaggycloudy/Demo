FROM python:3.9

WORKDIR /app/backend

COPY requirements.txt /app/backend
RUN apt-get update && apt-get install -y default-libmysqlclient-dev build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install -r requirements.txt

COPY . /app/backend

# Expose Django port
EXPOSE 8000

# Run migrations and start the app
CMD sh -c "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8000"
