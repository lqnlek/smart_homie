from flask import Flask, jsonify, request

app = Flask(__name__)

books = [
    { 'name': 'Harry Potter', 'amount': 1 },
    { 'name': 'Lord of the Rings', 'amount': 12 }
]

@app.route('/')
def hello_world():
    return "T'es pas au bon endroit, connard!"

@app.route('/books')
def get_incomes():
    return jsonify(books)


@app.route('/books', methods=['POST'])
def add_income():
    books.append(request.get_json())
    return '', 204