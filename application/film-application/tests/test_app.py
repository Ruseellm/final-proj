import pytest
from flask import Flask
from database import db, User, get_joyful_users, get_unjoyful_users, get_all_users

@pytest.fixture
def app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)
    
    with app.app_context():
        db.create_all()

    yield app

    with app.app_context():
        db.session.remove()
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

def test_get_users_lists(app, client):
    with app.app_context():
        user1 = User(username='Joey Tribbiani', joyful=True, imglink="https://upload.wikimedia.org/wikipedia/en/d/da/Matt_LeBlanc_as_Joey_Tribbiani.jpg")
        user2 = User(username='Ross Geller', joyful=False, imglink="https://i0.wp.com/manforhimself.com/wp-content/uploads/2021/05/Ross-geller-swept-back-hair-1200-GettyImages-908307.jpg?fit=1200%2C1200&ssl=1")
        user3 = User(username='Rachel Green', joyful=False, imglink="https://ik.imagekit.io/shortpedia/Voices/wp-content/uploads/2021/05/Rachel-Green-2.jpg")
        user4 = User(username='Monica Geller', joyful=False, imglink="https://upload.wikimedia.org/wikipedia/en/d/d0/Courteney_Cox_as_Monica_Geller.jpg")
        user5 = User(username='Chandler Bing', joyful=True, imglink="https://kaplan.co.uk/images/default-source/insights/chandler-bing.jpg")
        user6 = User(username='Phoebe Buffay', joyful=True, imglink="https://www.looper.com/img/gallery/phoebe-buffays-friends-timeline-explained/intro-1621661137.jpg")

        db.session.add(user1)
        db.session.add(user2)
        db.session.add(user3)
        db.session.add(user4)
        db.session.add(user5)
        db.session.add(user6)
        db.session.commit()
        assert len(all_users) == 6
        joyful_users = get_joyful_users()
        assert len(joyful_users) == 3
        unjoyful_users = get_unjoyful_users()
        assert len(unjoyful_users) == 3
