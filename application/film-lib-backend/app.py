# Flask web application
from flask import Flask, render_template, jsonify, request
import psycopg2
import uuid

app = Flask(__name__)

db_host = ''
db_port = '5432'
db_name = 'weightdb'
db_user = 'postgres'
db_password = 'admin'

class User:
    def __init__(self, name, email, password):
        self.name = name
        self.email = email
        self.password = password
        self.id = uuid.uuid1()

    def getname(self):
        return self.name

    def setname(self, name):
        self.name = name

    def getemail(self):
        return self.email

    def setemail(self, email):
        self.email = email

    def getpassword(self):
        return self.password

    def setpassword(self, password):
        self.password = password



def createUser(name, email, password):
    try:
        newuser = User(name, email, password)
        connection = psycopg2.connect(
            host=db_host,
            database=db_name,
            user=db_user,
            password=db_password
        )

        cursor = connection.cursor()
        insert_query = "INSERT INTO users (name, email, password, num_tickets) VALUES (%s, %s, %s, %s)"
        user_data = (newuser.getname(), newuser.get_email(), newuser.get_password())
        cursor.execute(insert_query, user_data)
        connection.commit()
        cursor.close()
        connection.close()
        print("Entry inserted successfully!")
        response = {
            'status': 'success',
            'name': name,
            'email':newuser.getemail(),
            'database_status': 'Data inserted successfully'
        }
        return jsonify(response)
    except (Exception, psycopg2.Error) as error:
        response = {
            'status': 'error',
            'message': 'Database error',
            'error_details': str(error)
        }
        return jsonify(response), 500

def getUser(email):
    try:
        # Establish a connection to the PostgreSQL database
        connection = psycopg2.connect(
            host=db_host,
            database=db_name,
            user=db_user,
            password=db_password
        )
        cursor = connection.cursor()
        select_query = "SELECT * FROM users WHERE email = %s"
        cursor.execute(select_query, (name,))
        result = cursor.fetchone()

        if result:
            # Retrieve the relevant information from the database
            name = result[0]
            email = result[1]

            response = {
                'status': 'success',
                'name': name,
                'email': email
            }
        else:
            response = {
                'status': 'error',
                'message': 'name not found in the database'
            }

        return jsonify(response)
    except (Exception, psycopg2.Error) as error:
        print("Error while getting data:", error)
        response = {
                'status': 'error',
                'message': 'error connecting to db'
            }
        return jsonify(response)




@app.route('/' , methods=["GET"])
def home():
    return render_template("homePage.html")

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
