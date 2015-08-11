import lib.operations as ops
import os
import yaml

with open(os.environ['WORKSPACE'] + "/gate/configurations/projects.yaml") as projects_file:
    projects = yaml.load(projects_file.read())

recombined_branch = os.environ['GERRIT_BRANCH']

for project in projects:
    git add -o replica location/project project['deploy-name']
    cd project['deploy-name']
    git fetch
    git branch recombined_branch
    rm -rf */.git
