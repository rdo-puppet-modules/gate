#
# Copyright (C) 2015 Red Hat, Inc.
#
# Author: Ben Kero <bkero@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Adds OPM CI path to LOAD_PATH
$:.unshift(File.dirname(File.dirname(__FILE__)))

require 'serverspec'

describe package('mongodb_server') do
  it { should be_installed.by('yum') }
end

describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

describe user('mongodb') do
  it { should exist }
  it { should belong_to_group 'mongodb' }
  it { should have_uid 184 }
end

describe group('mongodb') do
  it { should exist }
  it { should have_gid 999 }
end

describe file('/var/lib/mongodb') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'mongodb' }
  it { should be_grouped_into 'mongodb' }
end

describe file('/etc/mongod.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^bind_ip = 127.0.0.1$/ }
  its(:content) { should match /^fork=true$/ }
  its(:content) { should match /^dbpath=\/var\/lib\/mongodb$/ }
  its(:content) { should match /^pidfilepath=\/var\/lib\/mongodb$/ }
  its(:content) { should match /^journal = true$/ }
  its(:content) { should match /^noauth=true$/ }
end
