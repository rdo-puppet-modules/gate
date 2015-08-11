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


describe file('/etc/manila') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/manila/manila.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'manila' }
  it { should be_grouped_into 'manila' }
end

describe config('/etc/manila/manila.conf') do
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('manila') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/control_exchange').with_value('openstack') }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/sql_connection').with_value('mysql://manila:a_big_secret@127.0.0.1/manila?charset=utf8') }
  it { should contain_setting('DEFAULT/sql_idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/api_paste_config').with_value('/etc/manila/api-paste.ini') }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('manila.openstack.common.rpc.impl_kombu') }
  it { should contain_setting('DEFAULT/storage_availability_zone').with_value('nova') }
  it { should contain_setting('DEFAULT/rootwrap_config').with_value('/etc/manila/rootwrap.conf') }
  it { should contain_setting('DEFAULT/lock_path').with_value('/tmp/manila/manila_locks') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/manila') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('DEFAULT/nova_catalog_info').with_value('compute:nova:publicURL') }
  it { should contain_setting('DEFAULT/nova_catalog_admin_info').with_value('compute:nova:adminURL') }
  it { should contain_setting('DEFAULT/nova_api_insecure').with_value(false) }
  it { should contain_setting('DEFAULT/nova_admin_username').with_value('nova') }
  # TODO: Add nova support in upstream test0
  #it { should contain_setting('DEFAULT/nova_admin_password').with_value('')
  it { should contain_setting('DEFAULT/nova_admin_tenant_name').with_value('service') }
  it { should contain_setting('DEFAULT/nova_admin_auth_url').with_value('http://localhost:5000/v2.0') }
  it { should contain_setting('DEFAULT/network_api_class').with_value('manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin') }
  it { should contain_setting('DEFAULT/neutron_url').with_value('http://127.0.0.1:9696') }
  it { should contain_setting('DEFAULT/neutron_url_timeout').with_value(30) }
  it { should contain_setting('DEFAULT/neutron_admin_username').with_value('neutron') }
  # TODO: Add neutron support in upstream test
  #it { should contain_setting('DEFAULT/neutron_admin_password').with_value('')
  it { should contain_setting('DEFAULT/neutron_admin_tenant_name').with_value('service') }
  it { should contain_setting('DEFAULT/neutron_admin_auth_url').with_value('http://localhost:5000/v2.0') }
  it { should contain_setting('DEFAULT/neutron_api_insecure').with_value(false) }
  it { should contain_setting('DEFAULT/neutron_auth_strategy').with_value('keystone') }
  it { should contain_setting('DEFAULT/cinder_catalog_info').with_value('volume:cinder:publicURL') }
  it { should contain_setting('DEFAULT/cinder_http_retries').with_value(3) }
  it { should contain_setting('DEFAULT/cinder_api_insecure').with_value(false) }
  it { should contain_setting('DEFAULT/cinder_cross_az_attach').with_value(true) }
  it { should contain_setting('DEFAULT/cinder_admin_username').with_value('cinder') }
  # TODO: Add cinder suppport in upstream test
  #it { should contain_setting('DEFAULT/cinder_admin_password').with_value() }
  it { should contain_setting('DEFAULT/cinder_admin_tenant_name').with_value('service') }
  it { should contain_setting('DEFAULT/cinder_admin_auth_url').with_value('http://localhost:5000/v2.0') }
  it { should contain_setting('DEFAULT/osapi_share_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/auth_strategy').with_value('keystone') }
end

describe file('/etc/manila/api-paste.ini') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'manila' }
  it { should be_grouped_into 'manila' }
end

describe config('/etc/manila/api-paste.ini') do
  it { should contain_setting('filter:authtoken/auth_uri').with_value('http://localhost:5000/') }
  it { should contain_setting('filter:authtoken/service_protocol').with_value('http') }
  it { should contain_setting('filter:authtoken/service_host').with_value('localhost') }
  it { should contain_setting('filter:authtoken/service_port').with_value(5000) }
  it { should contain_setting('filter:authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('filter:authtoken/auth_host').with_value('localhost') }
  it { should contain_setting('filter:authtoken/auth_port').with_value(35357) }
  it { should contain_setting('filter:authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('filter:authtoken/admin_user').with_value('manila') }
  it { should contain_setting('filter:authtoken/admin_password').with_value('a_big_secret') }
end

