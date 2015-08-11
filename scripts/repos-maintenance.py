import lib.operations as ops
import os
import yaml

with open(os.environ['WORKSPACE'] + "/gate/configurations/projects.yaml") as projects_file:
    projects = yaml.load(projects_file.read())

#for project in projects:
for project in ['puppetlabs-sysctl']:
    base_dir = os.environ['WORKSPACE'] + "/" + projects[project]['deploy-name']
    try:
        os.mkdir(base_dir)
    except OSError:
        pass
    gitnome = ops.Polymerase(os.environ['WORKSPACE'] + "/gate/configurations/projects.yaml", project, base_dir)


    print "delete recomb branches in github"
    # cleanup github repos from recomb branches WIP
    gitnome.project.underlayer.add_git_remote('replica-mirror', 'github', projects[project]['replica']['name'])
    exe = ops.cmd('git for-each-ref --format="%(refname)" refs/remotes/replica-mirror/recomb*')
    recomb_branches = exe.output
    for branch in recomb_branches:
        ops.cmd('git push replica-mirror :%s' % branch.split('/')[:-2:-1]

    print "delete stale branches"
    # check branches (non-existing, dangling) WIP
    # dangling:
    ## get list of recomb-branches in gerrithub
    recomb_active_branches = list()
    exe = ops.cmd('git for-each-ref --format="%(refname)" refs/remotes/replica/recomb*')
    recomb_all_branches = map(lambda x: x.split('/')[:-2:-1], exe.output)
    infos = gitnome.project.replica.query_changes_json('status:open AND project:%s' % projects[project]['replica']['name'])
    for info in infos:
        recomb_active_branches.append(infos['branch'])
    recomb_stale_branches = list(set(recomb_all_branches) - set(recomb_active_branches))
    for branch in recomb_stale_branches:
        ops.cmd('git push replica :%s' % branch)
    ## query open changes in gerrithub, gather list of recomb-branches
    # delete every branch in (first list - second list)
    # non-existing:
    # for branch in watched branches
    # if branch-tag not it branches:
    # git branch branch-tag branch
    # if branch-patches not it branches:
    # git branch branch-tag branch


    # upload projects_config WIP
    #git fetch origin refs/meta/config:refs/remotes/origin/meta/config
    #git checkout meta/config
    #grep descr project.config
    #git diff project.config
    #git diff groups
    #cp /home/gcerami/OPMCI/conf/project.config /home/gcerami/OPMCI/conf/groups .
    #git commit -a -m "Changing Ownership"; git push origin HEAD:refs/meta/config ; cd .

    # update gerrit trigger configuration based on projects.yaml
