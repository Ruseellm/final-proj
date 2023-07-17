# Flask web application
from flask import Flask, render_template, jsonify, request
import mysql.connector
import uuid

userDb = mysql.connector.connect(
  host="localhost",
  user="admin",
  password="admin",
  database="users"
)

ticketDb = mysql.connector.connect(
  host="localhost",
  user="admin",
  password="admin",
  database="tickets"
)

app = Flask(__name__)

class User:
    def __init__(self, name, email, password):
        self.name = name
        self.email = email
        self.password = password
        self.numOfTickets = 0
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

    def get_num_tickets(self):
        return self.numOfTickets

    def set_num_tickets(self, num_tickets):
        self.numOfTickets = num_tickets

class Ticket:
    def __init__(self, name, status, assigned_user):
        self.name = name
        self.status = status
        self.assigned_user = assigned_user
        self.id = uuid.UUID(1)

    def getname(self):
        return self.name

    def setname(self, name):
        self.name = name

    def getstatus(self):
        return self.status

    def setstatus(self, status):
        self.status = status

    def getassigned_user(self):
        return self.assigned_user

    def setassigned_user(self, assigned_user):
        self.assigned_user = assigned_user
    
    def get_id(self):
        return self.id

def createUser(name, email, password):
    newuser = User(name, email, password)
    cursor = userDb.cursor()
    insert_query = "INSERT INTO users (name, email, password, num_tickets) VALUES (%s, %s, %s, %s)"
    user_data = (newuser.getname(), newuser.get_email(), newuser.get_password(), newuser.get_num_tickets())
    cursor.execute(insert_query, user_data)
    userDb.commit()  # For PostgreSQL, you need to commit the changes after executing the query.
    cursor.close()

def createTicket(name, assignee):
    newTicket = Ticket(name=name, assigned_user=assignee)
    cursor = userDb.cursor()
    insert_query = "INSERT INTO tickets (name, assignee, status) VALUES (%s, %s, %s)"  # Adjust the table name to 'tickets'.
    ticket_data = (newTicket.getname(), newTicket.getassigned_user(), newTicket.getstatus())  # Change the order of values.
    cursor.execute(insert_query, ticket_data)
    userDb.commit()  # For PostgreSQL, you need to commit the changes after executing the query.
    cursor.close()

def getUser(email):
    cursor = userDb.cursor()
    select_query = "SELECT * FROM users WHERE email = %s"
    params = (email,)  # Add a comma to make it a tuple.
    cursor.execute(select_query, params)
    user_info = cursor.fetchone()
    user = User(user_info[0], user_info[1], user_info[2], user_info[3], user_info[4])
    cursor.close()
    return user



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

@app.route('/tickets/<name>', methods=["GET"])
#get ticket per user
def getTickets():
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
