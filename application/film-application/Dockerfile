FROM python:3.8.3
WORKDIR /app
COPY templates/* /app/templates
COPY *.py /app/
COPY /tests/* /app/tests
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
RUN pip3 install --upgrade pip
RUN pip3 install Flask
EXPOSE 8080
CMD [ "python3", "app.py"]