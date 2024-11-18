# Create REST API:

**Protocol:**

**FLASK**

1. Install/Check **dependencies**python3,Pip,flask

   ```sh
   python3 --version
   pip --version
   pip install Flask
   ```
2. run flask check
   1. hello.py

   ```py
   from flask import Flask

   app = Flask(__name__)

   @app.route("/")
   def hello_world():
   return "Hello, World!"
   ```
   2. run HTTP request
   ```sh
   flask --app hello run

   Serving Flask app 'hello'

   Debug mode: off

   WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
   
   Running on http://127.0.0.1:5000
   
   Press CTRL+C to quit
   ```
3. **dependencies manager:**

**PIPENV**

   ```sh
   pip install pipenv
   ```

4. **src directory/files**(Pipfile, Pipenv.lock)
   ```sh
   mkdir projectname-flask-project && cd projectname-flask-project

   # use pipenv to create a Python 3 (--three) virtualenv for our project
   pipenv --three

   # install flask a dependency on our project
   pipenv install flask
   ```

5. **Pythin modules**
   1. Main module
      ```sh
      mkdir project_name && cd project_name
      touch __init__.py && index.py
      ```
   2. endpoit def
      ```py
      from flask import Flask
      app = Flask(__name__)


      @app.route("/")
      def hello_world():
         return "Hello, World!"
      ```
   3. **bootstrap** 
      1. Create 
      ```sh
      # move to the root directory
      cd ..

      touch bootstrap.sh

      chmod +x bootstrap.sh
      ```
      
      2. execute with flask and list interfaces  
      ```sh
      #!/bin/sh
      export FLASK_APP=./projectname/index.py
      pipenv run flask --debug run -h 0.0.0.0
      ```
      3. check

      ```sh
      Serving Flask app './cashman/index.py'
      Debug mode: on
      WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
      Running on all addresses (0.0.0.0)
      Running on http://127.0.0.1:5000
      Running on http://192.168.1.207:5000
      Press CTRL+C to quit
      ```
   4. Endpoints(index.py)
      1. create endpoint
         ```py
         rom flask import Flask, jsonify, request

         app = Flask(__name__)
         #Resource(object) represented in JSON
         resource = [
            { 'description': 'attrib1', 'attrib2': attrib2val }
         ]


         #Functionalities
         @app.route('/resource')#endpoint 1
         def get_resource():
            return jsonify(resource)

         @app.route('/resource', methods=['POST'])#endpoint 2
         def add_resource():
            resource.append(request.get_json())
            return '', 204
         ```
         2. test endpoint functionalities
         ```sh
         # start the cashman application
         ./bootstrap.sh &

         # get resources
         curl http://localhost:5000/resource

         # add new resources
         curl -X POST -H "Content-Type: application/json" -d '{
         "description": "attrib1.1",
         "attrib2.1": attrib2.1val
         }' http://localhost:5000/resource

         # check if lottery was added
         curl localhost:5000/resource
         ```
   5. Submodules encapsulated in py classes
      1. model directory

         ```py
         # create model directory inside the main module
         mkdir -p projectname/model

         # initialize it as a module
         touch projectname/model/__init__.py

         # create classe
         touch main_class.py
         ```
      2. class and subclasses def
         ```py
         import datetime as dt

         from marshmallow import Schema, fields

         #Superclass object
         class Superclass1(object):
            def __init__(self, description, amount, type):
               self.description = description
               self.attrib1 = attrib1
               self.created_at = dt.datetime.now()
               self.type = type

            def __repr__(self):
               return '<Transaction(name={self.description!r})>'.format(self=self)

         #Superclass schema
         class Superclass1Schema(Schema):
            description = fields.Str()
            attrib1 = fields.Number()
            created_at = fields.Date()
            type = fields.Str()
         ```

      3. install **serializer**

         ```sh
         pipenv install marshmallow
         ```
      4. subclasses
         1. create
            ```sh
            touch resource.py
            ```
         2. define
         ```py
         from marshmallow import post_load

         from .transaction import Transaction, TransactionSchema
         from .transaction_type import TransactionType


         class Resource(Superclass1):
            def __init__(self, attrib1, attrib2):
               super(Resource, self).__init__(attrib1, attrib2, Superclass1Type.RESOURCE)

            def __repr__(self):
               return '<Resource(name={self.attrib1!r})>'.format(self=self)


         class ResourceSchema(Superclass1Schema):
            @post_load
            def make_resource(self, data, **kwargs):
               return Resource(**data)
         ```
         3. supperclass type in python enum

         ```sh
         touch superclass1_type.py
         ```

         ```py
         from enum import Enum


         class TransactionType(Enum):
            RESOURCE = "RESOURCE"
         ```
   6.  Serializing and Deserializing Objects with Marshmallow(index.py)
         ```py
         from flask import Flask, jsonify, request

         from cashman.model.resource import Resource, resourceSchema
         from cashman.model.superclass_type import SuperclassType

         app = Flask(__name__)

         superclass1 = [
            Resources('attrib2', 0),
            Income('attrib3', 0),
         ]


         @app.route('/resource')
         def get_resource():
            schema = ResourceSchema(many=True)
            resource = schema.dump(
               filter(lambda s: s.type == Superclass1Type.RESOURCE, superclass1)
            )
            return jsonify(incomes)


         @app.route('/resource', methods=['POST'])
         def add_income():
            resource = ResourceSchema().load(request.get_json())
            superclass1.append(resource)
            return "", 204


         if __name__ == "__main__":
            app.run()
         ```

6. **Test API implementation**
   ```sh
   # start the application
   ./bootstrap.sh

   # get resources
   curl http://localhost:5000/resources

   # add a new resources
   curl -X POST -H "Content-Type: application/json" -d '{
      "attrib2": 0,
      "attrib1": "attrib1.1"
   }' http://localhost:5000/resources

   ```

7. **Dokerizing Flask App**
   1. create Dockerfile in root 
    ```sh
    touch Dockerfile
    ```
   2. add dependecies
      ```dk
      # Using lightweight alpine image
      FROM python:3.8-alpine

      # Installing packages
      RUN apk update
      RUN pip install --no-cache-dir pipenv

      # Defining working directory and adding source code
      WORKDIR /usr/src/app
      COPY Pipfile Pipfile.lock bootstrap.sh ./
      COPY projectname ./projectname

      # Install API dependencies
      RUN pipenv install --system --deploy

      # Start app
      EXPOSE 5000
      ENTRYPOINT ["/usr/src/app/bootstrap.sh"]
      ``` 
      3. create and run docker container
         ```sh
         docker build -t projectname .

         # run a new docker container named projectname
         docker run --name projectname \
            -d -p 5000:5000 \
            projectname

         # fetch incomes from the dockerized instance
         curl http://localhost:5000/resources/
         ```
8. Securing API with **Auth0**
   1. create decorator
      ```sh
      touch requires_auth
      ```
   2. format decorator
         ```py
         # Format error response and append status code

         def get_token_auth_header():
            """Obtains the access token from the Authorization Header
            """
            auth = request.headers.get("Authorization", None)
            if not auth:
               raise AuthError({"code": "authorization_header_missing",
                                 "description":
                                    "Authorization header is expected"}, 401)

            parts = auth.split()

            if parts[0].lower() != "bearer":
               raise AuthError({"code": "invalid_header",
                                 "description":
                                    "Authorization header must start with"
                                    " Bearer"}, 401)
            elif len(parts) == 1:
               raise AuthError({"code": "invalid_header",
                                 "description": "Token not found"}, 401)
            elif len(parts) > 2:
               raise AuthError({"code": "invalid_header",
                                 "description":
                                    "Authorization header must be"
                                    " Bearer token"}, 401)

            token = parts[1]
            return token

         def requires_auth(f):
            """Determines if the access token is valid
            """
            @wraps(f)
            def decorated(*args, **kwargs):
               token = get_token_auth_header()
               jsonurl = urlopen("https://"+AUTH0_DOMAIN+"/.well-known/jwks.json")
               jwks = json.loads(jsonurl.read())
               unverified_header = jwt.get_unverified_header(token)
               rsa_key = {}
               for key in jwks["keys"]:
                     if key["kid"] == unverified_header["kid"]:
                        rsa_key = {
                           "kty": key["kty"],
                           "kid": key["kid"],
                           "use": key["use"],
                           "n": key["n"],
                           "e": key["e"]
                        }
               if rsa_key:
                     try:
                        payload = jwt.decode(
                           token,
                           rsa_key,
                           algorithms=ALGORITHMS,
                           audience=API_AUDIENCE,
                           issuer="https://"+AUTH0_DOMAIN+"/"
                        )
                     except jwt.ExpiredSignatureError:
                        raise AuthError({"code": "token_expired",
                                       "description": "token is expired"}, 401)
                     except jwt.JWTClaimsError:
                        raise AuthError({"code": "invalid_claims",
                                       "description":
                                             "incorrect claims,"
                                             "please check the audience and issuer"}, 401)
                     except Exception:
                        raise AuthError({"code": "invalid_header",
                                       "description":
                                             "Unable to parse authentication"
                                             " token."}, 400)

                     _app_ctx_stack.top.current_user = payload
                     return f(*args, **kwargs)
               raise AuthError({"code": "invalid_header",
                                 "description": "Unable to find appropriate key"}, 400)
            return decorated
         ```
      3. controllers API
         ```py
         # Controllers API

         # This doesn't need authentication
         @app.route("/ping")
         @cross_origin(headers=['Content-Type', 'Authorization'])
         def ping():
            return "All good. You don't need to be authenticated to call this"

         # This does need authentication
         @app.route("/secured/ping")
         @cross_origin(headers=['Content-Type', 'Authorization'])
         @requires_auth
         def secured_ping():
            return "All good. You only get this message if you're authenticated"
         ```
