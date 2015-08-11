import yaml
import sys

projects_path = sys.argv[1]

with open(projects_path) as projects_file:
    projects = yaml.load(projects_file.read())

projects_vars = {"projects" : projects}

projects_vars_file = open('projects-vars.yaml', 'w')
yaml.dump(projects_vars, stream=projects_vars_file, explicit_start=True, default_flow_style=False, indent=4, canonical=False, default_style=False)
projects_vars_file.close()
