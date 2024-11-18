#!/bin/bash

# Flask REST API Setup Script

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
    pipenv --three
    pipenv install flask marshmallow

    # Make bootstrap.sh executable
    chmod +x bootstrap.sh

    echo -e "${GREEN}Project structure created successfully!${NC}"
    echo -e "${YELLOW}MANUAL ACTION REQUIRED: Edit the following files:${NC}"
    echo "1. project_name/index.py - Add Flask application code"
    echo "2. project_name/model/main_class.py - Add resource models"
    echo "3. bootstrap.sh - Add Flask run configuration"
}

# Main script execution
main() {
    echo -e "${GREEN}Flask REST API Setup Script${NC}"
    check_python
    check_pip
    install_dependencies
    create_project_structure
}

main
