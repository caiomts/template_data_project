# Data Project Template

Small bash script to generate the template
I use in data projects with Python.

## Running the script

You can save the script in the folder you save your projects 
or chmod-x and put the script in your PATH. The script works
with only one argument - your new project name.

```commandline
$ . dataproject {your project name}
```

## Template

```commandline
.
├── data
│   ├── interim
│   ├── processed
│   └── raw
├── Dockerfile
├── .flake8
├── .git
├── .github
│   └── workflows
├── .gitignore
├── Makefile
├── models
├── notebooks
├── pyproject.toml
├── README.md
├── results
├── scripts
│   ├── format.sh
│   └── test.sh
├── $1
├── tests
├── UNLICENSE
└── .venv

```
all Pre-made documents but UNLICENSE 
are created directly by the script with "echo". 
UNLICENSE is piped from CURL directly into the file.*

### .flake8

```commandline
[Flake8]
max-line-length = 79
extend-ignore = E203, E712
exclude =
    __init__.py
```
### pyproject.toml

```commandline
[build-system]
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
profile = "black"
```

### Makefile

```commandline
.PHONY: setup install format tests build

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
	sudo docker build --tag ? .
```

### format.sh

```commandline
#!/usr/bin/env bash

set -x
set -e

module=?

python -m black $module tests
python -m flake8 $module tests
python -m isort $module tests
```

### test.sh

```commandline
#!/usr/bin/env bash

set -x
set -e

python -m pytest
```