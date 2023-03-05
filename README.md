# Data Project Template

A simple bash script to generate the template
I use in data projects with Python.

## Quick Start

### Clone the repo

```
$ git clone https://github.com/caiomts/template_data_project.git
```

### Turning the script executable

```
$ cd template_data_project
$ chmod +x dataproject.sh
```

### How to run it

```
$ . /path/to/the/script/dataproject your_project_name
```
If you call it without arg, it'll ask you your project name.

```
$ . /path/to/the/script/dataproject
Project name is missing: 
```

The script will create a `$XDG_CONFIG_HOME/dataproject` folder with all needed 
files and configuration for the next time you call it.


## How I use it (Linux OS)

I keep a folder in my `HOME` with symlinks to all my shell scripts and I add this folder into my `PATH`.
This way I can call any shell script no matter where by name.

#### 1. Creating a folder in `HOME`.

```
$ cd ~
$ mkdir your_folder_name
```

#### 2. Adding the folder to your `PATH`.

In my case the bash config file is `.bashrc` in my `HOME`, but it can be `bash_profile` or another one depending
on the distro you are using.

```
$ echo 'export PATH="$PATH:$HOME/your_folder_name"' >> .bashrc
```

#### 3. Creating a symlink

```
$ ln -s /path/to/the/script/pyupdate.sh ~/your_folder_name/dataproject
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
|		└── ci.yaml	
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
├── **Project Name**
├── tests
├── UNLICENSE
└── .venv

```

