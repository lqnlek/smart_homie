#!/bin/sh
export FLASK_APP=./smarthomie/index.py
export PIPENV_IGNORE_VIRTUALENVS=1

pipenv run flask --debug run -h 0.0.0.0