# Performs sanity check for midstream
import lib.operations as ops
import os
import pprint

workspace = os.environ.get('WORKSPACE', os.environ['PWD'])

gitnome = ops.Polymerase(workspace + "/ci-scripts/scripts/projects.yaml",  os.environ['GERRIT_PROJECT'], os.environ['WORKSPACE'] + "/" + os.environ['GERRIT_PROJECT'])
gitnome.event_upstream_merge(os.environ['GERRIT_BRANCH'])
