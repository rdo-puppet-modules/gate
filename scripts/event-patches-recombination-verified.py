import lib.operations as ops
import os
import pprint

workspace = os.environ.get('WORKSPACE', os.environ['PWD'])

gitnome = ops.Polymerase(workspace + "/ci-scripts/scripts/projects.yaml",  os.environ['GERRIT_PROJECT'], os.environ['WORKSPACE'] + "/" + os.environ['GERRIT_PROJECT'])
gitnome.event_patches_recombine_approved(os.environ['GERRIT_CHANGE_ID'])
