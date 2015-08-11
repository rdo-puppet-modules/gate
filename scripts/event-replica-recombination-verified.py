# Performs sanity check for midstream
import lib.operations as ops
import os
import pprint

workspace = os.environ.get('WORKSPACE', os.environ['PWD'])

gitnome = ops.Polymerase(workspace + "/gate/configurations/projects.yaml",  os.environ['GERRIT_PROJECT'], os.environ['WORKSPACE'] + "/" + os.environ['GERRIT_PROJECT'])
gitnome.event_recombination_verified(os.environ['GERRIT_CHANGE_ID'])
