#!/bin/bash

# Flask REST API Setup Script

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Python installation
check_python() {
    echo -e "${YELLOW}Checking Python installation...${NC}"
    python3 --version
    if [ $? -ne 0 ]; then
        echo -e "${RED}Python3 not found. Please install Python.${NC}"
        exit 1
    fi
}

# Check and install pip
check_pip() {
    echo -e "${YELLOW}Checking pip installation...${NC}"
    pip --version
    if [ $? -ne 0 ]; then
        echo -e "${RED}pip not found. Installing pip...${NC}"
        python3 -m ensurepip --upgrade
    fi
}

# Install Flask and pipenv
install_dependencies() {
    echo -e "${YELLOW}Installing Flask and pipenv...${NC}"
    pip install Flask pipenv
}

# Create project structure
create_project_structure() {
    read -p "Enter project name: " PROJECT_NAME
    mkdir -p "$PROJECT_NAME/project_name/model"
    cd "$PROJECT_NAME"

    # Create initial files
    touch bootstrap.sh Pipfile
    touch project_name/__init__.py
    touch project_name/index.py
    touch project_name/model/__init__.py
    touch project_name/model/main_class.py

    # Setup pipenv
    pipenv --python 3
    pipenv install flask marshmallow

    # Make bootstrap.sh executable
    chmod +x bootstrap.sh

    echo -e "${GREEN}Project structure created successfully!${NC}"
    echo -e "${YELLOW}MANUAL ACTION REQUIRED: Edit the following files:${NC}"
    echo "1. project_name/index.py - Add Flask application code"
    echo "2. project_name/model/main_class.py - Add resource models"
    echo "3. bootstrap.sh - Add Flask run configuration"
    
    echo "RUN CHECK: Try running ./bootstrap.sh to verify the basic setup"
}

# Setup Docker
setup_docker() {
    echo -e "${YELLOW}Setting up Docker configuration...${NC}"
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
        echo "Visit https://docs.docker.com/get-docker/ for installation instructions."
        return 1
    fi

    # Create Dockerfile
    cat > Dockerfile << 'EOL'
FROM python:3.8-alpine

RUN apk update
RUN pip install --no-cache-dir pipenv

WORKDIR /usr/src/app
COPY Pipfile Pipfile.lock bootstrap.sh ./
COPY project_name ./project_name

RUN pipenv install --system --deploy

EXPOSE 5000
ENTRYPOINT ["/usr/src/app/bootstrap.sh"]
EOL

    echo -e "${GREEN}Dockerfile created successfully!${NC}"
    echo -e "${YELLOW}To build and run the Docker container:${NC}"
    echo "1. docker build -t $PROJECT_NAME ."
    echo "2. docker run --name $PROJECT_NAME -d -p 5000:5000 $PROJECT_NAME"
    
    echo "RUN CHECK: Try building and running the Docker container"
}

# Setup Auth0
setup_auth0() {
    echo -e "${YELLOW}Setting up Auth0 configuration...${NC}"
    
    # Install required packages
    pipenv install python-jose-cryptodome python-dotenv flask-cors

    # Create Auth0 configuration file
    mkdir -p config
    touch config/auth0_config.py
    
    # Create auth decorator file
    mkdir -p auth
    cat > auth/requires_auth.py << 'EOL'
from functools import wraps
from flask import request, _app_ctx_stack
from jose import jwt
from urllib.request import urlopen
import json

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.headers.get("Authorization", None)
        if not auth:
            return {"message": "Authorization header is required"}, 401

        try:
            token = auth.split(" ")[1]
            # Add your Auth0 domain and API audience here
            AUTH0_DOMAIN = 'YOUR_AUTH0_DOMAIN'
            API_AUDIENCE = 'YOUR_API_AUDIENCE'
            
            jsonurl = urlopen(f"https://{AUTH0_DOMAIN}/.well-known/jwks.json")
            jwks = json.loads(jsonurl.read())
            unverified_header = jwt.get_unverified_header(token)
            rsa_key = {}
            
            # Implementation continues as per the Auth0 documentation
            # Add your specific Auth0 validation logic here
            
            return f(*args, **kwargs)
        except Exception as e:
            return {"message": str(e)}, 401
            
    return decorated
EOL
    
    echo -e "${YELLOW}MANUAL ACTION REQUIRED:${NC}"
    echo "1. Update config/auth0_config.py with your Auth0 credentials"
    echo "2. Update auth/requires_auth.py with your specific Auth0 configuration"
    echo "3. Add the @requires_auth decorator to protected endpoints"
    
    echo "RUN CHECK: Test a protected endpoint with a valid Auth0 token"
}

# Create example protected endpoint
create_protected_endpoint() {
    cat >> project_name/index.py << 'EOL'

# Protected endpoint example
@app.route("/api/protected")
@requires_auth
def protected_endpoint():
    return jsonify({"message": "This is a protected endpoint"})
EOL

    echo -e "${GREEN}Protected endpoint example added to index.py${NC}"
}

# Main script execution
main() {
    echo -e "${GREEN}Flask REST API Setup Script${NC}"
    
    check_python
    check_pip
    install_dependencies
    create_project_structure
    
    # Ask about Docker setup
    read -p "Do you want to set up Docker? (y/n): " setup_docker_answer
    if [ "$setup_docker_answer" = "y" ]; then
        setup_docker
    fi
    
    # Ask about Auth0 setup
    read -p "Do you want to set up Auth0 authentication? (y/n): " setup_auth0_answer
    if [ "$setup_auth0_answer" = "y" ]; then
        setup_auth0
        create_protected_endpoint
    fi
    
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Review and update configuration files"
    echo "2. Add your API endpoints in project_name/index.py"
    echo "3. Run the application using ./bootstrap.sh"
    if [ "$setup_docker_answer" = "y" ]; then
        echo "4. Build and run the Docker container"
    fi
    if [ "$setup_auth0_answer" = "y" ]; then
        echo "5. Configure Auth0 settings and test protected endpoints"
    fi
}

main
