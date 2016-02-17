#
# Copyright (C) 2015 Red Hat, Inc.
#
# Author: Martin Magr <mmagr@redhat.com>
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

describe file('/etc/swift/swift.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
  its(:content) { should match '^swift_hash_path_suffix = secrete$' }
end

describe file('/etc/swift/object-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  its(:content) { should match 'pipeline = object-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6020' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = object-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  #its(:content) { should match 'object-replicator/concurrency' }
  #its(:content) { should match 'object-updater/concurrency' }
end

describe file('/etc/swift/container-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
  its(:content) { should match 'pipeline = container-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6021' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = container-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  its(:content) { should match 'concurrency' }
  its(:content) { should match 'concurrency' }
end

describe file('/etc/swift/account-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  its(:content) { should match 'pipeline = account-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6022' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = account-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  its(:content) { should match 'concurrency' }
  its(:content) { should match 'concurrency' }
end

describe file('/etc/swift/proxy-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  #its(:content) { should match 'pipeline:main/pipeline = healthcheck cache tempauth proxy-server' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 8080' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = proxy-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL1' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }
  its(:content) { should match 'log_handoffs = true' }
  its(:content) { should match 'allow_account_management = true' }
  its(:content) { should match 'account_autocreate = true' }
  its(:content) { should match 'user_admin_admin = admin .admin .reseller_admin' }
  its(:content) { should match 'log_name = swift' }
  its(:content) { should match 'signing_dir = /var/cache/swift' }
  its(:content) { should match 'paste.filter_factory = keystonemiddleware.auth_token:filter_factory' }
  its(:content) { should match 'auth_host = 127.0.0.1' }
  its(:content) { should match 'auth_port = 35357' }
  its(:content) { should match 'auth_protocol = http' }
  its(:content) { should match 'auth_uri = http://127.0.0.1:5000' }
  its(:content) { should match 'admin_tenant_name = services' }
  its(:content) { should match 'admin_user = swift' }
  its(:content) { should match 'admin_password = a_big_secret' }
  its(:content) { should match 'delay_auth_decision = 1' }
  its(:content) { should match 'cache = swift.cache' }
  its(:content) { should match 'include_service_catalog = False' }
  its(:content) { should match 'memcache_servers = 127.0.0.1:11211' }
end

