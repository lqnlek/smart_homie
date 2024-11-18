# Building a REST API with Flask: A Comprehensive Guide

## Prerequisites

### 1. Install Dependencies

Ensure you have the following installed:
- Python 3
- pip
- Flask
- pipenv

```sh
# Check Python and pip versions
python3 --version
pip --version

# Install Flask
pip install Flask
```

### 2. Project Setup with Pipenv

```sh
# Install pipenv
pip install pipenv

# Create project directory
mkdir my-flask-project
cd my-flask-project

# Create virtual environment
pipenv --three

# Install Flask in the virtual environment
pipenv install flask
```

### 3. Project Structure

```
my-flask-project/
│
├── Pipfile
├── Pipfile.lock
├── bootstrap.sh
└── project_name/
    ├── __init__.py
    ├── index.py
    └── model/
        ├── __init__.py
        ├── main_class.py
        ├── resource.py
        └── superclass1_type.py
```

### 4. First Flask Application (hello.py)

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello, World!"
```

Run with:
```sh
flask --app hello run
```

### 5. Creating Endpoints

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

resources = [
    {'description': 'example resource', 'attribute': 'value'}
]

@app.route('/resource')
def get_resource():
    return jsonify(resources)

@app.route('/resource', methods=['POST'])
def add_resource():
    resources.append(request.get_json())
    return '', 204
```

### 6. Object Serialization with Marshmallow

Install marshmallow:
```sh
pipenv install marshmallow
```

Example model class:
```python
import datetime as dt
from marshmallow import Schema, fields, post_load

class Resource:
    def __init__(self, description, amount, type):
        self.description = description
        self.amount = amount
        self.created_at = dt.datetime.now()
        self.type = type

class ResourceSchema(Schema):
    description = fields.Str()
    amount = fields.Number()
    created_at = fields.Date()
    type = fields.Str()

    @post_load
    def make_resource(self, data, **kwargs):
        return Resource(**data)
```

### 7. Dockerizing the Flask App

Create a Dockerfile:
```dockerfile
FROM python:3.8-alpine

RUN apk update
RUN pip install --no-cache-dir pipenv

WORKDIR /usr/src/app
COPY Pipfile Pipfile.lock bootstrap.sh ./
COPY project_name ./project_name

RUN pipenv install --system --deploy

EXPOSE 5000
ENTRYPOINT ["/usr/src/app/bootstrap.sh"]
```

Build and run:
```sh
docker build -t my-flask-project .
docker run --name my-flask-project -d -p 5000:5000 my-flask-project
```

### 8. Authentication with Auth0 

Create a decorator for token validation and add secured routes.

## Testing API

```sh
# Start application
./bootstrap.sh

# Get resources
curl http://localhost:5000/resources

# Add new resource
curl -X POST -H "Content-Type: application/json" -d '{
   "description": "New Resource",
   "amount": 100
}' http://localhost:5000/resources
```

## Troubleshooting

- Ensure all dependencies are installed
- Check virtual environment activation
- Verify file paths and imports
- Review error messages carefully
