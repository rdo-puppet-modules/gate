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

require 'spec_helper'


describe file('/etc/heat/') do
  it { should be_directory }
  it { should be_owned_by 'heat' }
  it { should be_grouped_into 'heat' }
  it { should be_mode 750 }
end

describe file('/etc/heat/heat.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'heat' }
  it { should be_grouped_into 'heat' }
end

describe config('/etc/heat/heat.conf') do
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('heat') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0') }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('heat.openstack.common.rpc.impl_kombu') }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('ec2authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0/ec2tokens') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('heat') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/heat') }
  it { should contain_setting('database/connection').with_value('mysql://heat:a_big_secret@127.0.0.1/heat?charset=utf8') }
  it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('heat_api/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('heat_api/bind_port').with_value(8004) }
  it { should contain_setting('heat_api/workers').with_value(0) }
  it { should contain_setting('DEFAULT/auth_encryption_key').with_value('1234567890AZERTYUIOPMLKJHGFDSQ12') }
  it { should contain_setting('DEFAULT/heat_stack_user_role').with_value('heat_stack_user') }
  it { should contain_setting('DEFAULT/heat_metadata_server_url').with_value('http://127.0.0.1:8000') }
  it { should contain_setting('DEFAULT/heat_waitcondition_server_url').with_value('http://127.0.0.1:8000/v1/waitcondition') }
  it { should contain_setting('DEFAULT/heat_watch_server_url').with_value('http://127.0.0.1:8003') }
  it { should contain_setting('DEFAULT/engine_life_check_timeout').with_value(2) }
  it { should contain_setting('DEFAULT/trusts_delegated_roles').with_value('heat_stack_owner') }
  it { should contain_setting('DEFAULT/deferred_auth_method').with_value('trusts') }
  #it { should contain_setting('DEFAULT/stack_domain_admin').with_value('heat_admin') }
  #it { should contain_setting('DEFAULT/stack_domain_admin_password').with_value(property['puppet-heat-keystone_domain_password']) }
  #it { should contain_setting('DEFAULT/stack_user_domain') }
  it { should contain_setting('heat_api_cfn/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('heat_api_cfn/bind_port').with_value(8000) }
  it { should contain_setting('heat_api_cfn/workers').with_value(0) }
  it { should contain_setting('heat_api_cloudwatch/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('heat_api_cloudwatch/bind_port').with_value(8003) }
  it { should contain_setting('heat_api_cloudwatch/workers').with_value(0) }
end

describe file('/etc/heat/policy.json') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'heat' }
end
