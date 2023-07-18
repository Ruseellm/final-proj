FROM python:3.8.3
RUN mkdir /app
WORKDIR /app
COPY film-lib-backend/* /app/
RUN mkdir templates
COPY film-lib-frontend/* /app/templates/
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
RUN pip3 install --upgrade pip
RUN pip3 install Flask
EXPOSE 8080
CMD [ "python3", "app.py"]