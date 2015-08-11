import lib.operations as ops
import os
import yaml

with open(os.environ['WORKSPACE'] + "/gate/configurations/projects.yaml") as projects_file:
    projects = yaml.load(projects_file.read())

#for project in projects:
for project in ['puppetlabs-rabbitmq']:
    if projects[project]['original']['watch-method'] == 'poll':
        base_dir = os.environ['WORKSPACE'] + "/" + project
        try:
            os.mkdir(base_dir)
        except OSError:
            pass
        gitnome = ops.Polymerase(os.environ['WORKSPACE'] + "/gate/configurations/projects.yaml", project, base_dir)
        gitnome.original_scan_branches()
