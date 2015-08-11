import yaml
import os
import sys
import re

projects_path = sys.argv[1]

with open(projects_path) as projects_file:
    projects = yaml.load(projects_file.read())

project_name = re.sub('.*/','',os.environ['GERRIT_PROJECT'])

project = projects[project_name]
project['name'] = project_name
project_vars = {"project" : project}

project_vars_file = open('project-vars.yaml', 'w')
yaml.dump(project_vars, stream=project_vars_file, explicit_start=True, default_flow_style=False, indent=4, canonical=False, default_style=False)
project_vars_file.close()
