import unittest
from app import app, Movie, Actor

class TestApp(unittest.TestCase):

    def setUp(self):
        app.testing = True
        self.client = app.test_client()

    def test_home_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Welcome to Film Library', response.data)

    def test_movies_endpoint(self):
        response = self.client.get('/movies')
        self.assertEqual(response.status_code, 200)
        # You can add additional assertions here to check the response data
        # For example, if you expect movies to be present in the response
        # self.assertIn(b'Movie Title', response.data)

    def test_actors_endpoint(self):
        response = self.client.get('/actors')
        self.assertEqual(response.status_code, 200)
        # You can add additional assertions here to check the response data
        # For example, if you expect actors to be present in the response
        # self.assertIn(b'Actor Name', response.data)

    def test_ping_endpoint(self):
        response = self.client.get('/ping')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['status'], 'success')
        self.assertEqual(response.json['message'], 'PONG')

if __name__ == '__main__':
    unittest.main()
