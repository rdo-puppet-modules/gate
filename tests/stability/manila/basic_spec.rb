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

require 'spec_helper_acceptance'
require 'beaker-rspec/helpers/serverspec'


describe 'apply default manifest (dup for expected state)' do
  it 'should work with no errors' do
    pp = <<-EOS
      class { '::openstack_integration':
        before => Class['::manila'] }
      class { '::openstack_integration::repos': 
        before => Class['::manila'] }

      class { '::manila':
        sql_connection      => 'mysql+pymysql://manila:a_big_secret@127.0.0.1/manila?charset=utf8',
        rabbit_userid       => 'manila',
        rabbit_password     => 'an_even_bigger_secret',
        rabbit_host         => '127.0.0.1',
        debug               => true,
        verbose             => true,
      }

	EOS
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
    # Comment out the next to lines and uncomment the previous to run locally
    #apply_manifest(pp, :catch_failures => true, :modulepath => "/usr/share/openstack-puppet/modules")
    #apply_manifest(pp, :catch_changes => true, :modulepath => "/usr/share/openstack-puppet/modules")
  end
end


 file('/etc/manila') do
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

describe file('/etc/manila/manila.conf') do
  its(:content) { should match 'rabbit_password = an_even_bigger_secret' }
  its(:content) { should match 'rabbit_userid = manila' }
  its(:content) { should match 'rabbit_virtual_host = /' }
  its(:content) { should match 'rabbit_use_ssl = false' }
  its(:content) { should match 'control_exchange = openstack' }
  its(:content) { should match 'amqp_durable_queues = false' }
  its(:content) { should match 'rabbit_host = 127.0.0.1' }
  its(:content) { should match 'rabbit_port = 5672' }
  its(:content) { should match 'rabbit_hosts = 127.0.0.1:5672' }
  its(:content) { should match 'rabbit_ha_queues = false' }
  its(:content) { should match(/^connection = mysql\+pymysql:\/\/manila:a_big_secret@127.0.0.1\/manila\?charset=utf8$/) }
  its(:content) { should match '^#sql_idle_timeout = 3600$' }
  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match '^api_paste_config = /etc/manila/api-paste.ini$' }
  its(:content) { should match '^rpc_backend = rabbit$' }
  its(:content) { should match '^storage_availability_zone = nova$' }
  its(:content) { should match 'rootwrap_config = /etc/manila/rootwrap.conf' }
  its(:content) { should match 'lock_path = /tmp/manila/manila_locks' }
  its(:content) { should match 'log_dir = /var/log/manila' }
  its(:content) { should match 'use_syslog = false' }
  its(:content) { should match 'nova_catalog_info = compute:nova:publicURL' }
  its(:content) { should match 'nova_catalog_admin_info = compute:nova:adminURL' }
  its(:content) { should match 'nova_api_insecure = false' }
  its(:content) { should match 'nova_admin_username = nova' }
  # TODO: Add nova support in upstream test0
  #its(:content) { should match 'nova_admin_password = ' }
  its(:content) { should match '^#nova_admin_tenant_name = service$' }
  its(:content) { should match '^#nova_admin_auth_url = http://localhost:5000/v2.0$' }
  its(:content) { should match '^#network_api_class = manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin$' }
  its(:content) { should match '^#neutron_url = http://127.0.0.1:9696$' }
  its(:content) { should match '^#neutron_url_timeout = 30$' }
  its(:content) { should match '^#neutron_admin_username = neutron$' }
  # TODO: Add neutron support in upstream test
  #its(:content) { should match 'neutron_admin_password = ')
  its(:content) { should match '^#neutron_admin_project_name = service$' }
  its(:content) { should match '^#neutron_admin_auth_url = http://localhost:5000/v2.0$' }
  its(:content) { should match '^#neutron_api_insecure = false$' }
  its(:content) { should match '^#neutron_auth_strategy = keystone$' }
  its(:content) { should match '^#cinder_catalog_info = volume:cinder:publicURL$' }
  its(:content) { should match '^#cinder_http_retries = 3$' }
  its(:content) { should match '^#cinder_api_insecure = false$' }
  its(:content) { should match '^#cinder_cross_az_attach = true$' }
  its(:content) { should match '^#cinder_admin_username = cinder$' }
  # TODO: Add cinder suppport in upstream test
  #its(:content) { should match 'cinder_admin_password = ) }
  its(:content) { should match '^#cinder_admin_tenant_name = service$' }
  its(:content) { should match '^#cinder_admin_auth_url = http://localhost:5000/v2.0$' }
  its(:content) { should match '^#osapi_share_listen = ::$' }
  its(:content) { should match '^#auth_strategy = keystone$' }
end

describe file('/etc/manila/api-paste.ini') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'manila' }
  it { should be_grouped_into 'manila' }
end
