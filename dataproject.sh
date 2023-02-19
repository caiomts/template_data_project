#!/usr/bin/env bash

error() {
	echo $1
	exit 1
}

[[ $# -lt 1 ]] && error 'The project name is missing.'

[[ -d $1 ]] && error 'This project already exists.'

[[ $1 =~ ^[0-9a-z]+[-_0-9a-z]+$ ]] || error 'Invalid name.'


mkdir -p $1/{$1,data/{raw,interim,processed},models,notebooks,tests,scripts,results,.github/workflows}

echo '.idea/
.ipynb_checkpoints
*/.ipynb_checkpoints/*
__pycache__/
*.py[cod]
*$py.class
.Python
build/
develop-eggs/
dist/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/
.venv/
/site
data/
.code/' > $1/.gitignore

touch $1/README.md

curl https://unlicense.org/UNLICENSE > $1/UNLICENSE

echo '[build-system]
requires = ["flit_core >=3.2,<4"]
build-backend = "flit_core.buildapi"

[project]
name = "?"
authors = [{name = "?", email = "?"}]
dynamic = ["version", "description"]
readme = "README.md"
requires-python = "?"
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
target-version = ["py311"]
skip-string-normalization = true

[tool.isort]
profile = "black"' > $1/pyproject.toml

echo '[Flake8]
max-line-length = 79
extend-ignore = E203, E712
exclude =
    __init__.py' > $1/.flake8

touch $1/Dockerfile

echo '.PHONY: setup install format tests build

VPATH = data:models:results

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
	. scripts/format.sh

tests:
	. scripts/test.sh

build:
	sudo docker build --tag ? .' > $1/Makefile

echo '#!/usr/bin/env bash

set -x
set -e

module=?

python -m black $module tests
python -m flake8 $module tests
python -m isort $module tests' > $1/scripts/format.sh

echo '#!/usr/bin/env bash

set -x
set -e

python -m pytest' > $1/scripts/test.sh


cd $1 && make setup && git init
