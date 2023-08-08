# Flask web application
from flask import Flask, render_template, jsonify
import psycopg2

app = Flask(__name__)

# Replace the following with your PostgreSQL database connection details
db_connection_config = {
    'host': 'your_host',
    'database': 'film_library',
    'user': 'your_username',
    'password': 'your_password'
}


class Film:
    def __init__(self, title, director, year, genre):
        self.title = title
        self.director = director
        self.year = year
        self.genre = genre

class Actor:
    def __init__(self, first_name, last_name, gender):
        self.first_name = first_name
        self.last_name = last_name
        self.gender = gender



@app.route('/films')
def index():
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(**db_connection_config)
        
        # Create a cursor to interact with the database
        cursor = conn.cursor()

        # Query all films from the 'films' table
        cursor.execute("SELECT * FROM films")
        rows = cursor.fetchall()

        # Create a list to store film objects
        films = []
        for row in rows:
            title, director, year, genre = row
            film = Film(title, director, year, genre)
            films.append(film)

        # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('films.html', films=films)
    except Exception as e:
        return f"Error: {e}"

@app.route('/actors')
def actors():
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(**db_connection_config)

        # Create a cursor to interact with the database
        cursor = conn.cursor()

        # Query all actors/actresses from the 'actors' table
        cursor.execute("SELECT * FROM actors")
        actor_rows = cursor.fetchall()

        # Create a list to store actor objects
        actors = []
        for row in actor_rows:
            first_name, last_name, gender = row
            actor = Actor(first_name, last_name, gender)
            actors.append(actor)

        # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('actors.html', actors=actors)
    except Exception as e:
        return f"Error: {e}"

@app.route('/film_category')
def film_category(Category):
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(**db_connection_config)

        # Create a cursor to interact with the database
        cursor = conn.cursor()

        # Query all films from films table
        cursor.execute("SELECT * FROM films WHERE F_Category LIKE '%${Category}%'")
        film_rows = cursor.fetchall()

        # Create a list to store film objects
        films = []
        for row in rows:
            title, director, year, genre = row
            film = Film(title, director, year, genre)
            films.append(film)
            
         # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('films.html', films=films)
    except Exception as e:
        return f"Error: {e}"


@app.route('/' , methods=["GET"])
def home():
    return render_template("Film_Library.html")

@app.route('/ping', methods=["GET"])
#test
def test():
    response = {
        'status': 'success',
        'massage' : 'PONG'
    }
    return jsonify(response)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
