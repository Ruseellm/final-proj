FROM python:3.8.3

# Set the working directory to /app
WORKDIR /app

# Copy the necessary files to the container
COPY templates/*.html /app/templates/
COPY *.py /app/
COPY tests/* /app/tests/

# Install the required dependencies
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2

RUN pip3 install --upgrade pip
RUN pip3 install Flask

# Run the unit tests
# RUN python3 -m unittest /app/tests/test_app.py

# Expose port 8080 for the Flask application
EXPOSE 8080

# Start the Flask application
CMD ["python3", "app.py"]
