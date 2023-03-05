#!/usr/bin/env bash

# Defining LC_ALL.
LC_ALL=C

# Error message.
error_msg[1]='This project already exists.'
error_msg[2]='Invalid name. Valid characters: [-_0-9a-z]'

error() {
	echo ${error_msg[$1]}
	exit $1
}

# Project name.
[[ $# -ne 1 ]] && read -p 'Project name is missing: ' -t 20 project_name || project_name=$1

# Project already exist.
[[ -d $project_name ]] && error 1

# Invalid project name.
[[ $project_name =~ ^[-_a-z0-9]+$ ]] || error 2

# config path
path_config=$HOME/.config/dataproject

# files to save into config folder
unlicense='https://unlicense.org/UNLICENSE'


gitignore='https://www.toptal.com/developers/gitignore/api/python,pycharm,jupyternotebooks'


pyproject='[build-system]
requires = ["flit_core >=3.2,<4"]
build-backend = "flit_core.buildapi"
[project]
name = project_name
authors = name_email
dynamic = ["version", "description"]
readme = "README.md"
requires-python = ""
dependencies = [
	"pandas >=?",
	"numpy >=?",
	"optuna >=?",
	"scikit-learn >=?",
	"fastapi>=?",
	"pyarrow >=?",
]
[project.urls]
Home = "?"
[project.optional-dependencies]
test = [
	"pytest >=?",
	"pytest-cov >=?",
	"httpx ==?",
]
docs = [
	"mkdocs >=?",
	"mkdocstrings[python] >=?",
]
dev = [
	"black >=?",
	"flake8 >=?",
	"isort >=?",
]
[tool.black]
line-length = 79
target-version = [""]
skip-string-normalization = true
[tool.isort]
profile = "black"'


flake8='[Flake8]
max-line-length = 79
extend-ignore = E203, E712
exclude =
     __init__.py'


dockerfile='FROM python:3

WORKDIR /src

COPY ./pyproject.toml /src/pyproject.toml

RUN pip install --no-cache-dir --upgrade flit

RUN flit install

COPY ./project_name /src/project_name

COPY ./models /src/models

CMD/ENTRYPOINT...'


makefile='.PHONY: setup install format build run tests

VPATH = project_name:data:models:results

pyenv = . .venv/bin/activate &&

setup:
	python -m venv .venv
	$(pyenv) \
	python -m pip install -U pip && \
	python -m pip install -U flit

install:
	$(pyenv) \
	python -m flit install --symlink --deps all

format:
	$(pyenv) bash scripts/format.sh

tests:
	$(pyenv) python -m pytest

build:
	sudo docker build --tag project_name .

run:
	sudo docker run -d --name project_name'


format='#!/usr/bin/env bash

set -x
set -e

python -m black project_name tests
python -m flake8 project_name tests
python -m isort project_name tests'


tests='#!/usr/bin/env bash

set -x
set -e

python -m pytest'


init='"""Sort Description."""

__version__ = '0.1.0''


ci_git='
name: ci
on: [push]
jobs:
  run:
    runs-on: [ubuntu-latest]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: ci
        run: |
          python -m pip install flit
          python -m flit install --symlink --deps all
          python -m black project_name tests
          python -m flake8 project_name tests
          python -m isort project_name tests
          python -m pytest'


# author name
config() {
	echo "[{name = \"$1\", email = \"$2\"}]"
}

# If not config it creates config and save files in it.
[[ -d $path_config ]] || { mkdir -p $path_config; \
	( curl -s $unlicense > $path_config/UNLICENSE; \
	curl -s $gitignore > $path_config/.gitignore; \
	echo "$flake8" > $path_config/.flake8 & \
	echo "$pyproject" > $path_config/pyproject.toml & \
	echo "$dockerfile" > $path_config/Dockerfile & \
	echo "$makefile" > $path_config/Makefile & \
	echo "$format" > $path_config/format.sh & \
	echo "$tests" > $path_config/tests.sh & \
	echo "$init" > $path_config/__init__.py & \
	echo "$ci_git" > $path_config/ci.yaml & \
	read -p 'pyproject.toml name : ' -t 20 name && \
        read -p 'pyproject.toml email : ' -t 20 email && \
	config "${name}" "${email}" > $path_config/config.txt  ) }


# Creates project folders
mkdir -p $project_name/{$project_name,data/{raw,interim,processed},models,notebooks,tests,scripts,results,.github/workflows}

# read name email
author=$(cat $path_config/config.txt)

# unlicense
cp $path_config/UNLICENSE $path_config/.gitignore $path_config/.flake8  $project_name/

# pyproject/toml
sed "s/project_name/$project_name/g ; s/name_email/$author/g" \
	$path_config/pyproject.toml > $project_name/pyproject.toml

# Dockerfile
sed "s/project_name/$project_name/g" $path_config/Dockerfile > $project_name/Dockerfile

# Makefile
sed "s/project_name/$project_name/g" $path_config/Makefile > $project_name/Makefile

# format
sed "s/project_name/$project_name/g" $path_config/format.sh > $project_name/scripts/format.sh

# tests
sed "s/project_name/$project_name/g" $path_config/tests.sh > $project_name/scripts/tests.sh

# inits
touch $project_name/tests/__init__.py
cp $path_config/__init__.py $project_name/$project_name/__init__.py

# ci_git
sed "s/project_name/$project_name/g" $path_config/ci.yaml > $project_name/.github/workflows/ci.yaml

# Setup
hook='#!/bin/sh

set -x
set -e

make format
make tests'

cd $project_name && make setup &> /dev/null && \
	git init && &> /dev/null \
	echo "$hook" > .git/hooks/pre-commit

echo "the $project_name setup is done."
