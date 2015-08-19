# Performs sanity check for midstream
import json
import pprint
import re
import subprocess
import sys
import os
import copy
import yaml
import tempfile
from contextlib import contextmanager
from collections import OrderedDict

import colorlog
log = colorlog.get()

@contextmanager
def pushd(newDir):
    previousDir = os.getcwd()
    os.chdir(newDir)
    yield
    os.chdir(previousDir)


def shell(commandline, show_stdout=True, show_stderr=True):
    process = subprocess.Popen(commandline, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    process.output, process.errors = process.communicate()
    process.output = process.output.split('\n')
    process.errors = process.errors.split('\n')
    if process.returncode == 0:
        outlog = log.success
    else:
        outlog = log.error
    log.info("---- executing command: %s" % commandline)
    log.info("---- stdout:")
    if show_stdout:
        for line in process.output:
            outlog(line)
    else:
        outlog("*** Suppressed")
    log.info("---- stderr:")
    if show_stderr:
        for line in process.errors:
            outlog(line)
    else:
        outlog("*** Suppressed")
    log.info("---- end command")
    # remove blank lines from output for further processing
    while '' in process.output:
        process.output.remove('')
    while '' in process.errors:
        process.errors.remove('')
    return process


class Gerrit(object):

    def __init__(self, name, host, project_name):
        self.host = host
        self.name = name
        self.project_name = project_name
        self.url = "ssh://%s/%s" % (host, project_name)

    def query_changes_json(self, query):
        changes_infos = list()
        cmd = shell('ssh %s gerrit query --current-patch-set --format json %s' % (self.host,query))
        log.debug(pprint.pformat(cmd.output))
        for change_json in cmd.output:
            if change_json !='':
                change = json.loads(change_json)
                if "type" not in change or change['type'] != 'stats':
                    changes_infos.append(change)

        log.debug("end query json")
        return changes_infos

    def approve_change(self, number, patchset):
        shell('ssh %s gerrit review --code-review 2 --verified 1 %s,%s' % (self.host, number, patchset))

    def submit_change(self, number, patchset):
        shell('ssh %s gerrit review --publish --project %s %s,%s' % (self.host, self.project_name, number, patchset))
        shell('ssh %s gerrit review --submit --project %s %s,%s' % (self.host, self.project_name, number, patchset))
        cmd = shell('ssh %s gerrit query --format json "change:%s AND status:merged"' % (self.host, number))
        if cmd.output[:-1]:
            return True
        return False

    def upload_change(self, branch, topic):
        shell('git checkout %s' % branch)
        shell('git review -D -r %s -t "%s" %s' % (self.name, topic, branch))
        cmd = shell('ssh %s gerrit query --current-patch-set --format json "topic:%s AND status:open"' % (self.host, topic))
        shell('git checkout parking')
        log.debug(pprint.pformat(cmd.output))
        if not cmd.output[:-1]:
            return None
        gerrit_infos = json.loads(cmd.output[:-1][0])
        infos = self.normalize_infos(gerrit_infos)
        change = Change(infos=infos)
        return change

    def get_query_string(self, criteria, ids, branch=None):
        query_string = '\(%s:%s' % (criteria, ids[0])
        for change in ids[1:]:
            query_string = query_string + " OR %s:%s" % (criteria,change)
        query_string = query_string + "\) AND project:%s AND NOT status:abandoned" % (self.project_name)
        if branch:
            query_string = query_string + " AND branch:%s " % branch
        log.debug("search in upstream gerrit: %s" % query_string)
        return query_string

    @staticmethod
    def approved(infos):
        if not infos['approvals']:
            code_review = 0
            verified = 0
        else:
            code_review = -2
            verified = -1
            for approval in range(0, len(infos['approvals'])):
                patchset_approval = infos['approvals'][approval]
                if patchset_approval['type'] == 'Code-Review':
                    code_review = max(code_review, int(patchset_approval['value']))
                if patchset_approval['type'] == 'Verified':
                    verified = max(verified, int(patchset_approval['value']))
        log.debug("change %s max approvals: CR: %d, V: %d" % (infos['id'], code_review, verified))
        if code_review >= 2 and verified >= 1:
           log.debug("change %s approved for submission if all precedent are approved too")
           return True
        return False

    def normalize_infos(self, gerrit_infos):
        infos = {}
        infos['revision'] = gerrit_infos['currentPatchSet']['revision']
        infos['parent'] = gerrit_infos['currentPatchSet']['parents'][0]
        infos['patchet_number'] = gerrit_infos['currentPatchSet']['number']
        infos['patchset_revision'] = gerrit_infos['currentPatchSet']['revision']
        infos['project-name'] = gerrit_infos['project']
        infos['branch'] = gerrit_infos['branch']
        infos['id'] = gerrit_infos['id']
        infos['previous-commit'] = infos['parent']
        infos['subject'] = gerrit_infos['commitMessage']
        if 'topic' in gerrit_infos:
            infos['topic'] = gerrit_infos['topic']
        infos['number'] = gerrit_infos['number']
        infos['status'] = gerrit_infos['status']
        infos['approvals'] = None
        if 'approvals' in gerrit_infos['currentPatchSet']:
            infos['approvals'] = gerrit_infos['currentPatchSet']['approvals']
        if gerrit_infos['status'] == 'NEW' or gerrit_infos['status'] == 'DRAFT':
            infos['status'] = 'PRESENT'
        if gerrit_infos['status'] != "MERGED" and self.approved(infos):
            infos['status'] = "APPROVED"

        return infos

    def get_changes_info(self, search_values, search_field='change', key_field='id', branch=None):
        infos = dict()
        query_string = self.get_query_string(search_field, search_values, branch=branch)
        changes_infos = self.query_changes_json(query_string)

        for gerrit_infos in changes_infos:
            norm_infos = self.normalize_infos(gerrit_infos)
            infos[norm_infos[key_field]] = norm_infos

        return infos

    def get_changes_by_id(self, search_values, search_field='change', key_field='id', branch=None):
        changes = dict()
        query_string = self.get_query_string(search_field, search_values, branch=branch)
        changes_infos = self.query_changes_json(query_string)

        for gerrit_infos in changes_infos:
            infos = self.normalize_infos(gerrit_infos)
            change = Change(infos=infos, repo=self)
            changes[infos[key_field]] = change

        return changes

    def get_recombinations(self, commits):
        recombinations = OrderedDict()
        for line in commits:
            if re.search('Change-Id: ', line):
                recombinations[re.sub(r'\s*Change-Id: ', '', line.rstrip('\n'))] = None

        return recombinations


class Git(object):

    def get_revision(self, revision_name):
        cmd = shell('git rev-parse %s' % revision_name)
        revision = cmd.output[0].rstrip('\n')
        return revision

    def get_commits(self, branch, revision_start, revision_end):
        log.debug("Interval: %s..%s" % (revision_start, revision_end))

        os.chdir(self.directory)
        shell('git checkout parking')
        cmd = shell('git log --topo-order --reverse --pretty=raw %s..%s --no-merges' % (revision_start, revision_end))

        return cmd.output

    def get_merge_commits(self, revision_start, revision_end):
        merge_commits = []
        cmd = shell('git log --topo-order --reverse --pretty=format:"%%H %%P" %s..%s --merges' % (revision_start, revision_end))
        for line in map(lambda line: line.rstrip('\n'), cmd.output):
            merge = {}
            merge['commit'] = line.split(' ')[0]
            merge['parents'] = line.split(' ')[1:]
            merge_commits.append(merge)

        return merge_commits

    def get_changes_by_id(self, search_values, search_field='commit', key_field='revision', branch=None):
        changes = dict()
        for revision in search_values:
            infos = {}
            cmd = shell('git show -s --pretty=format:"%%H %%P" %s' % (revision))
            infos['id'], infos['parent'] = cmd.output[0].split(' ')[0:2]
            infos['revision'] = infos['id']
            if not branch:
                log.error("for git repositories you must specify a branch")
                sys.exit(1)
            else:
                infos['branch'] = branch
            infos['project-name'] = self.project_name
            change = Change(infos=infos, repo=self)
            changes[infos[key_field]] = change
        return changes


class LocalRepo(Git):

    def __init__(self, project_name, directory):
        self.directory = directory
        self.project_name = project_name
        self.remotes = {}
        os.chdir(self.directory)
        shell('git init')
        shell('git checkout --orphan parking')
        shell('git commit -a -m "parking"')
        shell('scp -p gerrithub:hooks/commit-msg .git/hooks/')

    def addremote(self, name, url):
        os.chdir(self.directory)
        shell('git remote add %s %s' % (name, url))
        shell('git fetch %s' % name)

    def add_gerrit_remote(self, name, location, project_name):
        self.remotes[name] = Gerrit(name, location, project_name)
        self.addremote(name, self.remotes[name].url)

    def add_git_remote(self, name, location, project_name):
        self.remotes[name] = RemoteGit(name, location, self.directory, project_name)
        self.addremote(name, self.remotes[name].url)

    def track_branch(self, branch, remote_branch):
        shell('git checkout parking')
        shell('git branch --track %s %s' %(branch, remote_branch))

    def delete_branch(self, branch):
        shell('git checkout parking')
        shell('git branch -D %s' % branch)

    def recombine(self, commit_message_filename, pick_branch, recombination_branch, starting_revision, pick_revision, merge_revision):
        shell('git fetch replica')
        shell('git fetch original')
        retry_merge = True
        first_try = True
        while retry_merge:
            shell('git checkout %s' % pick_branch)

            shell('git checkout -B %s %s' % (recombination_branch, starting_revision))

            # TODO: handle exception: two identical changes in row creates no
            # diff, so no commit can be created
            log.info("Creating remote disposable branch on replica")
            shell('git push replica HEAD:%s' % recombination_branch)

            cmd = shell("git merge --squash --no-commit %s %s" % (pick_revision, merge_revision))

            shell('git status')

            if cmd.returncode != 0:
                log.warning("Merge check with master-patches failed")
                resolution = False
                if first_try:
                    log.warning("Trying automatic resolution")
                    resolution = self.resolve_conflicts(cmd.output)
                    first_try = False
                    if not resolution:
                        shell('git push replica :%s' % recombination_branch)
                        log.error("Resolution failed. Exiting")
                        os.unlink(commit_message_filename)
                        sys.exit(1)
                    else:
                        # reset, resolve, and retry
                        shell('git reset --hard %s' % recombination_branch)
                        shell('git checkout %s' % pick_branch)
                        shell('git branch -D %s' % recombination_branch)
                        shell('git push replica :%s' % recombination_branch)
                else:
                    shell('git push replica :%s' % recombination_branch)
                    os.unlink(commit_message_filename)
                    log.critical("Merge failed even after resolution. You're on your own, sorry. Exiting")
                    sys.exit(1)
            else:
                retry_merge = False

        shell("git commit -F %s" % (commit_message_filename))
        os.unlink(commit_message_filename)
        shell('git checkout %s' % pick_branch)

    def sync_replica(self, branch, commit):
        os.chdir(self.directory)
        shell('git fetch replica')
        shell('git branch --track replica-%s remotes/replica/%s' % (branch, branch))
        shell('git checkout replica-%s' % branch)
        cmd = shell('git merge --ff-only %s' % commit)
        if cmd.returncode != 0:
            log.debug(cmd.output)
            log.critical("Error merging. Exiting")
            sys.exit(1)
        cmd = shell('git push replica HEAD:%s' % branch)
        if cmd.returncode != 0:
            log.debug(cmd.output)
            log.critical("Error pushing the merge. Exiting")
            sys.exit(1)
        shell('git checkout parking')
        shell('git branch -D replica-%s' % branch)

    def push_merge(self, recombination_attempt):
        # FIXME: checkout from merge commit if it exists, not the simple commit
        branch, starting_revision, merge_revision = recombination_attempt
        shell('git fetch replica')
        shell('git branch --track replica-%s remotes/replica/%s' % (branch, branch))
        shell('git checkout replica-%s' % branch)
        shell('git checkout -B %s-tag %s' % (branch, starting_revision))
        shell("git merge %s" % (merge_revision))

        shell('git push -f replica HEAD:%s-tag' % (branch))

        shell('git checkout parking')
        shell('git branch -D %s-tag' % branch)
        shell('git branch -D replica-%s' % branch)

    def resolve_conflicts(self, output):
        return True


class RemoteGit(Git):

    def __init__(self, name, location, directory, project_name):
        self.name = name
        self.url = "git@%s:%s" % (location, project_name)
        self.directory = directory
        self.project_name = project_name

    def get_recombinations(self, commits):
        recombinations = OrderedDict()
        for line in commits:
            if re.search('^commit ', line):
                recombinations[re.sub(r'^commit ', '', line.rstrip('\n'))] = None

        return recombinations


class Change(object):

    def __init__(self, repo=None, infos=None):
        if infos:
            self.revision = infos['revision']
            self.branch = infos['branch']
            if 'id' in infos:
                self.uuid = infos['id']
            elif 'uuid' in infos:
                self.uuid = infos['uuid']
            self.parent = infos['parent']
            self.previous_commit = infos['parent']
            if 'status' in infos:
                self.status = infos['status']
            if 'subject' in infos:
                self.subject = infos['subject']
            self.project_name = infos['project-name']
            if 'topic' in infos:
                self.topic = infos['topic']
            if 'number' in infos:
                self.number = infos['number']
            if 'patchet_number' in infos:
                self.patchset_number = infos['patchet_number']
            if 'patchset_revision' in infos:
                self.patchset_revision = infos['patchset_revision']
        else:
            self.branch = None
            self.topic = None
        self.merge_commit = None

        self.repo = None
        if repo:
            self.repo = repo

    def find_merge(self, merge_commits):
        # TODO: implement better git-find-merge to find to which merge a commit belongs
        # in gerrit is simple, merged branches are always formed by 1 commit
        # in git things may be more difficult
        # in git we must wait for ALL the commits in a merged branch before
        # committing the merge commit
        for merge_commit in merge_commits:
            if self.revision in merge_commit['parents'][1]:
                log.info("%s is part of merge commit %s" % (self.revision, merge_commit['commit']))
                self.previous_commit = merge_commit['parents'][0]
                self.merge_commit = merge_commit['commit']
                break

    def submit(self):
        return self.repo.submit_change(self.number, self.patchset_number)

    def approve(self):
        return self.repo.approve_change(self.number, self.patchset_number)

    def upload(self):
        result_change = self.repo.upload_change(self.branch, self.topic)
        if result_change:
            self.number = result_change.number
            self.uuid = result_change.uuid
            log.info("Recombination with Change-Id %s uploaded in replica gerrit with number %s" % (self.uuid, self.number))
        else:
            shell('git push replica :%s' % self.branch)
            return False

        return True


class Recombination(Change):

    def __init__(self, project, infos=None):
        self.project = project
        if infos:
            super(Recombination, self).__init__(repo=self.project.replica, infos=infos)
            self.decode_subject()
        else:
            super(Recombination, self).__init__(repo=self.project.replica)
            self.subject = None
            self.patches_queue = None
            self.own_merge_commit = None
            self.replica_revision = None
            self.original = Change(repo=self.project.original)
            self.patches = Change(repo=self.project.replica)
            self.replica = Change(repo=self.project.replica)

    def decode_subject(self):
        log.debug(self.subject)
        try:
            data = yaml.load(self.subject)
        except ValueError:
            log.error("Subject not in yaml")
            exit(1)
        recomb_data = data['recombination']
        if 'mutation' in recomb_data:
            self.patches = self.project.replica.get_changes_by_id([recomb_data['mutation']['id']])[recomb_data['mutation']['id']]
            self.replica = self.project.underlayer.get_changes_by_id([recomb_data['replica']['id']], branch=recomb_data['replica']['branch'])[recomb_data['replica']['id']]
            main_source = self.replica
            merge_commits = self.project.underlayer.get_merge_commits(self.replica.parent, self.replica.revision)
            self.replica.find_merge(merge_commits)
        elif 'diversity' in recomb_data:
            self.patches = self.project.underlayer.get_changes_by_id([recomb_data['diversity']['id']], branch=recomb_data['diversity']['branch'])[recomb_data['diversity']['id']]
            self.original = self.project.original.get_changes_by_id([recomb_data['original']['id']], branch=recomb_data['original']['branch'])[recomb_data['original']['id']]
            main_source = self.original
            merge_commits = self.project.underlayer.get_merge_commits(self.original.parent, self.original.revision)
            self.original.find_merge(merge_commits)

        merge_revision = self.patches.revision
        if main_source.merge_commit:
            starting_revision = main_source.merge_commit
        else:
            starting_revision = main_source.revision
        self.recombination_attempt = (data['target-branch'], starting_revision, merge_revision)

    def attempt(self, main_source_name, patches_source_name):
        # patches_revision = self.project.get_revision(self.patches.revision)
        if main_source_name == 'original' and patches_source_name == 'diversity':
            main_source = self.original
            patches_source = self.patches
        elif main_source_name == 'replica' and patches_source_name == 'mutation':
            main_source = self.replica
            patches_source = self.patches
        else:
            log.critical("I don't know how to attempt this recombination")
            sys.exit(1)
        pick_revision = main_source.revision
        pick_branch = main_source.branch
        starting_revision = main_source.previous_commit
        merge_revision = patches_source.revision
        merge_branch = patches_source.branch
        recombination_branch = self.branch
        log.info("Checking compatibility between %s and %s-patches" % (self.original.branch, self.original.branch))
        subject = {
            "target-branch": self.original.branch,
            "recombination": {
                main_source_name : {
                    "branch": pick_branch,
                    "revision": pick_revision,
                    "id": main_source.uuid
                },
                patches_source_name: {
                    "branch": merge_branch,
                    "revision": merge_revision,
                    "id" : patches_source.uuid
                }
            }
        }
        fd, commit_message_filename = tempfile.mkstemp(prefix="recomb-", suffix=".yaml", text=True)
        os.close(fd)
        with open(commit_message_filename, 'w') as commit_message_file:
            commit_message_file.write("Recombination: %s\n" % pick_branch)
            yaml.safe_dump(subject, commit_message_file, default_flow_style=False, indent=4, canonical=False, default_style=False)
        self.project.underlayer.track_branch(pick_branch, 'remotes/%s/%s' % (main_source_name, pick_branch))
        self.project.underlayer.recombine(commit_message_filename, pick_branch, recombination_branch, starting_revision, pick_revision, merge_revision)
        self.recombination_attempt = (self.original.branch, pick_revision, merge_revision)
        self.project.underlayer.delete_branch(pick_branch)

    def generate_tag_branch(self):
        self.project.underlayer.push_merge(self.recombination_attempt)

    def sync_replica(self):
        if self.original.merge_commit:
            commit = self.original.merge_commit
        else:
            commit = self.original.revision
        log.info("Advancing replica branch %s to %s " % (self.original.branch, commit))
        self.project.underlayer.sync_replica(self.original.branch, commit)

class Project(object):

    def __init__(self, project_name, project_info, local_dir):

        log.info('Current project:\n' + pprint.pformat(project_info))
        self.original_project = project_info['original']
        self.replica_project = project_info['replica']
        self.deploy_name = project_info['deploy-name']

        self.underlayer = LocalRepo(project_name, local_dir)

        self.underlayer.add_gerrit_remote('replica', self.replica_project['location'], self.replica_project['name'])

        self.replica = self.underlayer.remotes['replica']

        if self.original_project['type'] == 'gerrit':
            self.underlayer.add_gerrit_remote('original', self.original_project['location'], self.original_project['name'])

        elif self.original_project['type'] == 'git':
            self.underlayer.add_git_remote('original', self.original_project['location'], self.original_project['name'])

        self.original = self.underlayer.remotes['original']

        self.commits = {}
        #self.recombinations_attempts = []

    def get_recombination(self, search_value, search_field='change', key_field='id', branch=None):
        infos = self.replica.get_changes_info([search_value], search_field=search_field, key_field=key_field, branch=branch)
        if search_value in infos:
            recombination = Recombination(self, infos=infos[search_value])
            return recombination
        return None

    def recombine_from_patches(self, patches_change_id):
        recombinations = OrderedDict()

        patches_change = self.replica.get_changes_by_id([patches_change_id])[patches_change_id]
        recombination = self.get_recombination(patches_change_id, search_field='topic', key_field='topic')

        if not recombination:
            recombination = Recombination(self)
            recombination.patches = patches_change
            recombination.patches.repo = self.replica

            recombination.original = Change(repo=self.original)
            recombination.original.branch = re.sub('-patches','', recombination.patches.branch)

            change = Change(repo=self.replica)
            change.branch = recombination.original.branch
            change.revision = self.underlayer.get_revision("remotes/replica/%s" % recombination.original.branch)
            change.parent = self.underlayer.get_revision("remotes/replica/%s~1" % recombination.original.branch)
            change.previous_commit = change.parent
            change.uuid = change.revision
            merge_commits = self.underlayer.get_merge_commits(change.parent, change.revision)
            change.find_merge(merge_commits)

            recombination.replica = change

            recombination.branch = "recomb-patches-%s-%s" % (recombination.replica.branch, recombination.replica.revision)
            recombination.topic = patches_change_id
            recombination.status = "MISSING"

        recombinations[patches_change_id] = recombination
        return recombinations

    def interval(self, branch, revision_start, revision_end):
        self.commits['revisions'] = self.underlayer.get_commits(branch, revision_start, revision_end)
        commits = self.commits['revisions']
        recombinations = self.original.get_recombinations(commits)


        if recombinations:
            ids = list(recombinations)
            log.debugvar("ids")

            self.commits['merge_commits'] = self.underlayer.get_merge_commits(revision_start, revision_end)
            merge_commits = self.commits['merge_commits']

            log.debugvar('merge_commits')
            # Just sets the right order
            for recomb_id in ids:
                recombinations[recomb_id] = None

            original_changes = self.original.get_changes_by_id(ids, branch=branch)
            replicas_infos = self.replica.get_changes_info(ids, search_field='topic', key_field='topic')
            replica_revision = self.underlayer.get_revision("remotes/replica/%s" % branch)
            patches_revision = self.underlayer.get_revision("remotes/replica/%s-patches" % branch)
            patches_change = self.underlayer.get_changes_by_id([patches_revision], branch="%s-patches" % branch)[patches_revision]

            for recomb_id in ids:
                if recomb_id in replicas_infos:
                    recombinations[recomb_id] = Recombination(self, infos=replicas_infos[recomb_id])
                else:
                    recombinations[recomb_id] = Recombination(self)
                    recombinations[recomb_id].status = "MISSING"
                    recombinations[recomb_id].branch = "recomb-original-%s-%s" % (branch, original_changes[recomb_id].revision)
                    recombinations[recomb_id].topic = recomb_id
                recombinations[recomb_id].replica = Change(repo=self.replica)
                recombinations[recomb_id].replica.revision = replica_revision
                recombinations[recomb_id].replica.branch = branch

                original_changes[recomb_id].find_merge(merge_commits)
                recombinations[recomb_id].original = original_changes[recomb_id]

                #patches_change = Change(repo=self.replica)
                #patches_change.branch = '%s-patches' % branch
                #patches_change.revision = patches_revision

                recombinations[recomb_id].patches = patches_change

            for recomb_id in ids:
                log.debugvar('recomb_id')
                recomb = recombinations[recomb_id].__dict__
                log.debugvar('recomb')

        return recombinations

class Polymerase(object):

    status_impact = {
        "MERGED": 2,
        "APPROVED": 1,
        "PRESENT": 1,
        "MISSING": 0
    }

    def __init__(self, projects_file_name, project_full_name, local_dir, project_file_format='yaml'):
        with open(projects_file_name) as projects_file:
            projects = yaml.load(projects_file.read())

        project_name = re.sub('.*/', '', project_full_name)
        try:
            project_info = projects[project_name]
        except KeyError:
            log.critical("project %s not found. Add to project file or filter events." % project_name)
            exit(1)
        self.project = Project(project_name, project_info, local_dir)

    def get_slices(self, recombinations):
        slices = {
            "MERGED": [],
            "APPROVED": [],
            "PRESENT": [],
            "MISSING": [],
        }
        previous_status = None
        previous_impact = None
        current_slice = {}

        # Slice
        for index, recomb_id in enumerate(list(recombinations)):
            replica_change = recombinations[recomb_id]

            log.info("evaluating slices for recombination with id: %s" % recomb_id)

            # creates slices to apply to change list
            # every status may have multiple slices, but this situation is tolerated
            # only between PRESENT' and 'APPROVED' statuses
            # any other complicated mix is a violation of upstream order
            status = replica_change.status
            impact =  self.status_impact[status]
            previous_change_id = None
            log.debug("impact: %s, status: %s, recomb_id: %s" % (impact, status, recomb_id))
            # Handle current status slice, archive previous slice
            try:
                segment = current_slice[status]
            except KeyError:
                if previous_status:
                    slices[previous_status].append(copy.deepcopy(current_slice[previous_status]))
                    del(current_slice[previous_status])
                current_slice[status] = {}
                segment = current_slice[status]
                segment['start'] = index
                segment['end'] = index + 1
                log.debug("slices new set: %s from %d to %d" % (status, index, index + 1))
            # init/extend current slice
            if previous_status:
                log.debug("previous impact: %s" % previous_impact)
                log.debug("previous status: %s" % previous_status)
                if impact > previous_impact:
                    list_recomb = list(recombinations)
                    log.debugvar('list_recomb')
                    log.critical("Constraint violation error: status %s at index %d (change:%s) of changes list in interval is more advanced than previous status %s at index %d (change: %s)" % (status, index, recomb_id, previous_status, index-1, previous_change_id))
                    log.critical("This means that midstream is broken")
                    sys.exit(1)
                if status == previous_status:
                    segment['end'] = segment['end'] + 1
                    log.debug("same status '%s' at index %d" % (status, index))
            # end of status list
            if index == len(list(recombinations)) - 1:
                    slices[status].append(copy.deepcopy(current_slice[status]))
                    del(current_slice[status])

            previous_status = status
            previous_impact = impact
            previous_change_id = recomb_id

        return slices

    def test_recombination(self, recomb_id, main_source, patches_source):
        recombination = self.recombinations[recomb_id]
        recombination.attempt(main_source, patches_source)
        log.info("Merge check with master-patches successful, ready to create review")
        if not recombination.upload():
            log.error("upload of recombination with change %s did not succeed. Exiting" % recomb_id)
            sys.exit(1)

    def submit_recombination(self, recomb_id):
        recombination = self.recombinations[recomb_id]
        recomb = recombination.__dict__
        log.debugvar('recomb')
        log.infoi("Approved replica recombination %s is about to be submitted for merge" % recombination.number)
        if recombination.submit():
            log.success("Submission of recombination %s succeeded" % recombination.number)
        else:
            log.error("Submission of recombination %s failed" % recombination.number)
            sys.exit(1)
        recombination.generate_tag_branch()

    def scan_original_distance(self):

        slices = self.get_slices(self.recombinations)

        log.debugvar('slices')
        # Master sync on merged changes
        # we really need only the last commit in the slice
        # we advance the master to that, and all the others will be merged too
        if slices['MERGED']:
            # one or more changes are merged in midstream, but missing in master
            # master is out of sync, changes need to be pushed
            # but check first if the change was changed with a merge commit
            # if yes, push THAT to master, if not, it's just a fast forward
            log.warning("branch is out of sync with original")
            segment = slices['MERGED'][0]
            recomb_id = list(self.recombinations)[segment['end'] - 1]
            recombination = self.recombinations[recomb_id]
            recombination.sync_replica()

        # Gerrit operations from approved changes
        # NOthing 'approved' can be merged if it has some "present" before in the history
        skip_list = set()
        for index, approved_segment in enumerate(slices['APPROVED']):
            for present_segment in slices['PRESENT']:
                if present_segment['start'] < approved_segment['start']:
                    skip_list.add(index)

        for index in list(skip_list)[::-1]:
            segment = slices['APPROVED'].pop(index)
            for recomb_id in list(self.recombinations)[segment['start']:segment['end']]:
                log.warning("Change %s is approved but waiting for previous unapproved changes, skipping" % recomb_id)

        # Merge what remains
        for segment in slices['APPROVED']:
            for recomb_id in list(self.recombinations)[segment['start']:segment['end']]:
                self.submit_recombination(recomb_id)
                self.recombinations[recomb_id].sync_replica()

        # Notify of presence
        for segment in slices['PRESENT']:
            for recomb_id in list(self.recombinations)[segment['start']:segment['end']]:
                recombination = self.recombinations[recomb_id]
                log.warning("Change %s already present in midstream gerrit as change %s and waiting for approval" % (recomb_id, recombination.number))

        # Gerrit operations for missing changes
        for segment in slices['MISSING']:
            for recomb_id in list(self.recombinations)[segment['start']:segment['end']]:
                log.warning("Change %s is missing from midstream gerrit" % recomb_id)
                self.test_recombination(recomb_id, 'original', 'diversity')


    def original_scan_branches(self, branches=None):
        if not branches:
            log.warning("no branches specified")
            try:
                branches = self.project.original_project['watch-branches']
                log.warning("using defined watch branches")
            except KeyError:
                log.error("no branches specified")
                exit(1)

        for branch in branches:
            revision_start = 'remotes/replica/%s' % (branch)
            revision_end = 'remotes/original/%s' % (branch)
            self.recombinations = self.project.interval(branch, revision_start, revision_end)
            self.scan_original_distance()

    def event_upstream_merge(self, original_branch):
        revision_start = 'remotes/replica/%s' % (original_branch)
        revision_end = 'remotes/original/%s' % (original_branch)
        self.recombinations = self.project.interval(original_branch, revision_start, revision_end)

        self.scan_original_distance()

    def event_recombination_verified(self, recombination_id):
        recombination = self.project.get_recombination(recombination_id)

        revision_start = 'remotes/replica/%s' % (recombination.original.branch)
        revision_end = 'remotes/original/%s' % (recombination.original.branch)
        self.recombinations = self.project.interval(recombination.original.branch, revision_start, revision_end)
        self.scan_original_distance()

    def event_patches_patchset(self, patches_change_id):
        self.recombinations = self.project.recombine_from_patches(patches_change_id)
        change = self.recombinations[patches_change_id].__dict__
        orig_change = self.recombinations[patches_change_id].original.__dict__
        repl_change = self.recombinations[patches_change_id].replica.__dict__
        patch_change = self.recombinations[patches_change_id].patches.__dict__
        log.debugvar('change')
        log.debugvar('orig_change')
        log.debugvar('repl_change')
        log.debugvar('patch_change')
        if self.recombinations[patches_change_id].status == "MISSING":
            self.test_recombination(patches_change_id, 'replica', 'mutation')
        else:
            log.warning("Master patches recombination present as number %s and waiting for approval" % self.recombinations[patches_change_id].number)

    def event_patches_recombine_verified(self):
        pass

    def event_patches_recombine_approved(self, recombination_id):

        self.recombinations = OrderedDict()
        self.recombinations[recombination_id] = self.project.get_recombination(recombination_id)

        if self.recombinations[recombination_id].patches.status != "MERGED":
            self.recombinations[recombination_id].patches.approve()
            if not self.recombinations[recombination_id].patches.submit():
                log.error("Originating change submission failed")
                sys.exit(1)
        if self.recombinations[recombination_id].status != "MERGED":
            self.submit_recombination(recombination_id)
        else:
            log.warning("Recombination already submitted")
        # update existing recombination from upstream changes
        # for change in midstream_gerrit.gather_current_merges(patches_revision):
        #    local_repo.merge_fortests(change['upstream_revision'], patches_revision)
        #    upload new patchset with updated master-patches and updated message on midstream changes with old master_patches
