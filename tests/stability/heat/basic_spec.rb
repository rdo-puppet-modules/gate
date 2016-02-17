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

describe file('/etc/heat/') do
  it { should be_directory }
  it { should be_owned_by 'heat' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end

describe file('/etc/heat/heat.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'heat' }
  its (:content) { should match 'rabbit_host = 127.0.0.1' }
  its (:content) { should match 'rabbit_port = 5672' }
  its (:content) { should match 'rabbit_hosts = 127.0.0.1:5672' }
  its (:content) { should match 'rabbit_userid = heat' }
  its (:content) { should match 'rabbit_password = an_even_bigger_secret' }
  its (:content) { should match 'rabbit_virtual_host = /' }
  its (:content) { should match 'rabbit_use_ssl = False' }
  its (:content) { should match 'amqp_durable_queues = False' }
  its (:content) { should match 'auth_host=127.0.0.1' }
  its (:content) { should match 'auth_port=35357' }
  its (:content) { should match 'auth_protocol=http' }
  its (:content) { should match 'auth_uri = http://127.0.0.1:5000/v2.0' }
  its (:content) { should match 'rpc_backend = rabbit' }
  its (:content) { should match 'debug = True' }
  its (:content) { should match 'verbose = True' }
  its (:content) { should match 'auth_uri = http://127.0.0.1:5000/v2.0/ec2tokens' }
  its (:content) { should match 'admin_tenant_name=services' }
  its (:content) { should match 'admin_user=heat' }
  its (:content) { should match 'admin_password=a_big_secret' }
  its (:content) { should match 'log_dir = /var/log/heat' }
  its (:content) { should match(/connection = mysql\+pymysql:\/\/heat:a_big_secret@127.0.0.1\/heat\?charset=utf8/) }
  its (:content) { should match 'idle_timeout = 3600' }
  its (:content) { should match 'use_syslog = false' }
  its (:content) { should match 'bind_host = 0.0.0.0' }
  its (:content) { should match 'bind_port = 8004' }
  its (:content) { should match 'workers = 0' }
  its (:content) { should match 'auth_encryption_key = 1234567890AZERTYUIOPMLKJHGFDSQ12' }
  its (:content) { should match 'heat_stack_user_role = heat_stack_user' }
  its (:content) { should match 'heat_metadata_server_url =http://127.0.0.1:8000' }
  its (:content) { should match 'heat_waitcondition_server_url = http://127.0.0.1:8000/v1/waitcondition' }
  its (:content) { should match 'heat_watch_server_url =http://127.0.0.1:8003' }
  its (:content) { should match 'engine_life_check_timeout = 2' }
  its (:content) { should match 'trusts_delegated_roles =heat_stack_owner' }
  its (:content) { should match 'deferred_auth_method = trusts' }
  #its (:content) { should match 'stack_domain_admin = heat_admin' }
  #its (:content) { should match 'stack_domain_admin_password = property['puppet-heat-keystone_domain_password']) }
  #its (:content) { should match 'stack_user_domain' }
  its (:content) { should match 'bind_host = 0.0.0.0' }
  its (:content) { should match 'bind_port = 8000' }
  its (:content) { should match 'workers = 0' }
  its (:content) { should match 'bind_host = 0.0.0.0' }
  its (:content) { should match 'bind_port = 8003' }
  its (:content) { should match 'workers = 0' }
end

describe file('/etc/heat/policy.json') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'heat' }
end
