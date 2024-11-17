# Smart_homie


## Stack

- Python Flask application with :
    - Backend (allowing create, edit, delete books)
    - API (get books)

- SQLAlchemy ORM for database communication
- SQLite database



# post command
➜  ~ curl -X POST -H "Content-Type: application/json" -d '{
  "name": "lottery",       
  "amount": 1000.0
}' http://localhost:5000/books
