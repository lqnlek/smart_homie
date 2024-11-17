# Smart_homie


## Stack

- Python Flask application with :
    - Backend (allowing create, edit, delete books)
    - API (get books)

- SQLAlchemy ORM for database communication
- SQLite database

## Tutorial

- https://auth0.com/blog/developing-restful-apis-with-python-and-flask/#-span-id--python-classes----span--Mapping-Models-with-Python-Classes

# post command
➜  ~ curl -X POST -H "Content-Type: application/json" -d '{
  "name": "lottery",       
  "amount": 1000.0
}' http://localhost:5000/books
