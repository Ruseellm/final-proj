# Flask Web Application for Film Library

This is a simple Flask web application that provides endpoints to view movies and actors/actresses information from a PostgreSQL database. The application also includes a home page and a ping endpoint for testing.

## Prerequisites

1. Python 3.x installed on the machine.
2. PostgreSQL database with a table named 'movies' and a table named 'actors' that contain movie and actor/actress information, respectively.
3. Docker (optional) - If you want to containerize the application.

## Installation

1. Clone the repository to your local machine.
2. Install the required Python packages using pip:

```
pip install Flask psycopg2
```

## Configuration

In the `app.py` file, replace the following placeholders with your PostgreSQL database connection details:

```python
db_connection_config = {
    'host': 'your_host',
    'database': 'film_library',
    'user': 'your_username',
    'password': 'your_password'
}
```

## Usage

1. Run the Flask application locally:

```bash
python app.py
```

The web application will be accessible at `http://localhost:8080/`.

2. Test Flask Application - 
```bash
python -m unittest test_app.py
```
3. Docker (optional): If you want to containerize the application, create a Docker image using the provided Dockerfile:

```bash
docker build -t film-library-app .
```

Run the Docker container:

```bash
docker run -p 8080:8080 film-library-app
```

## Endpoints

1. Home Page: `http://localhost:8080/`

2. Movies: `http://localhost:8080/movies`
   - Displays a list of movies available in the database.

3. Actors/Actresses: `http://localhost:8080/actors`
   - Displays a list of actors/actresses available in the database.

4. Ping Endpoint (for testing): `http://localhost:8080/ping`
   - Returns a JSON response with status 'success' and message 'PONG'.

## Kubernetes Deployment

If you want to deploy the application to Kubernetes, use the provided Kubernetes deployment YAML files:

1. Create the deployment:

```bash
kubectl apply -f deployment.yaml
```

2. Create the service:

```bash
kubectl apply -f service.yaml
```

## Helm Deployemnt
```bash
cd helm-chart
helm package movie-library
helm install movie-library ./movie-library-0.1.0.tgz

```

Please note that in a production environment, you should use secrets to store sensitive information like database credentials, rather than hardcoding them in the deployment files.