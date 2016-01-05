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
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'trove':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'trove@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Trove resources
      class { '::trove':
        database_connection   => 'mysql+pymysql://trove:a_big_secret@127.0.0.1/trove?charset=utf8',
        rabbit_userid         => 'trove',
        rabbit_password       => 'an_even_bigger_secret',
        rabbit_host           => '127.0.0.1',
        nova_proxy_admin_pass => 'a_big_secret',
      }
      class { '::trove::db::mysql':
        password => 'a_big_secret',
      }
      class { '::trove::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::trove::api':
        keystone_password => 'a_big_secret',
        identity_uri      => 'http://127.0.0.1:35357/',
        auth_uri          => 'http://127.0.0.1:5000/',
        debug             => true,
        verbose           => true,
      }
      class { '::trove::client': }
      class { '::trove::conductor':
        debug   => true,
        verbose => true,
      }
      class { '::trove::taskmanager':
        debug   => true,
        verbose => true,
      }
      class { '::trove::quota': }
    EOS
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
    # Comment out the next to lines and uncomment the previous to run locally
    #apply_manifest(pp, :catch_failures => true, :modulepath => "/usr/share/openstack-puppet/modules")
    #apply_manifest(pp, :catch_changes => true, :modulepath => "/usr/share/openstack-puppet/modules")
  end
end


describe file('/etc/trove') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/trove/trove.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'trove' }

  its(:content) { should match(/^connection = mysql\+pymysql:\/\/trove:a_big_secret@127.0.0.1\/trove\?charset=utf8$/) }
  #TODO: due to bug in module this is not set correctly 
  #its(:content) { should match 'database/idle_timeout = 3600 }
  its(:content) { should match '^verbose=True$' }
  its(:content) { should match '^debug=True$' }
  its(:content) { should match '^bind_host=0.0.0.0$' }
  its(:content) { should match '^bind_port=8779$' }
  its(:content) { should match '^backlog=4096$' }
  its(:content) { should match '^trove_api_workers=1$' }
  its(:content) { should match '^nova_proxy_admin_user=admin$' }
  its(:content) { should match '^nova_proxy_admin_pass=a_big_secret$' }
  its(:content) { should match '^nova_proxy_admin_tenant_name=admin$' }
  its(:content) { should match '^control_exchange=trove$' }
  its(:content) { should match(/^trove_auth_url=http:\/\/127.0.0.1:5000\/$/) }
  #its(:content) { should match '^auth_host = 127.0.0.1$' }
  #its(:content) { should match '^auth_port = 35357$' }
  #its(:content) { should match '^auth_protocol = http$' }
  its(:content) { should match '^admin_tenant_name=services$' }
  its(:content) { should match '^admin_user=trove$' }
  its(:content) { should match '^admin_password=a_big_secret$' }
  its(:content) { should match '^#log_file=/var/log/trove/trove.log$' }
  its(:content) { should match '^log_dir=/var/log/trove$' }
  #its(:content) { should match '^use_syslog=False$' }
  its(:content) { should match '^rabbit_password=an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_userid=trove$' }
  its(:content) { should match '^rabbit_virtual_host=/$' }
  its(:content) { should match '^rabbit_use_ssl=False$' }
  its(:content) { should match '^amqp_durable_queues=False$' }
  its(:content) { should match '^rabbit_host=127.0.0.1$' }
  its(:content) { should match '^rabbit_port=5672$' }
  its(:content) { should match '^rabbit_hosts=127.0.0.1:5672$' }
  its(:content) { should match '^rabbit_ha_queues=False$' }
  its(:content) { should match '^network_label_regex=.*$' }
  its(:content) { should match '^network_driver=trove.network.neutron.NeutronDriver$' }
  its(:content) { should match '^taskmanager_queue=taskmanager$' }
end

describe file('/etc/trove/trove-conductor.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'trove' }

  its(:content) { should match(/^connection = mysql\+pymysql:\/\/trove:a_big_secret@127.0.0.1\/trove\?charset=utf8$/) }
  #TODO: due to bug in module this is not set correctly
  #its(:content) { should match 'database/idle_timeout = 3600 }
  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match '^trove_auth_url = http://localhost:5000/v2.0$' }
  its(:content) { should match '^nova_proxy_admin_user=admin$' }
  its(:content) { should match '^nova_proxy_admin_tenant_name=admin$' }
  its(:content) { should match '^nova_proxy_admin_pass=a_big_secret$' }
  its(:content) { should match '^control_exchange = trove$' }
  its(:content) { should match '^rabbit_password=an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_userid=trove$' }
  its(:content) { should match '^rabbit_virtual_host=/$' }
  its(:content) { should match '^rabbit_use_ssl=False$' }
  its(:content) { should match '^amqp_durable_queues=False$' }
  #its(:content) { should match '^rabbit_notification_topic = notifications$' }
  its(:content) { should match '^rabbit_host=127.0.0.1$' }
  its(:content) { should match '^rabbit_port=5672$' }
  its(:content) { should match '^rabbit_hosts=127.0.0.1:5672$' }
  its(:content) { should match '^rabbit_ha_queues=False$' }
  its(:content) { should match '^log_file=/var/log/trove/trove-conductor.log$' }
  its(:content) { should match '^log_dir=/var/log/trove$' }
  its(:content) { should match '^use_syslog=False$' }
end

describe file('/etc/trove/trove-taskmanager.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'trove' }

  its(:content) { should match(/^connection = mysql\+pymysql:\/\/trove:a_big_secret@127.0.0.1\/trove\?charset=utf8$/) }
  #TODO: due to bug in module this is not set correctly
  #its(:content) { should match 'database/idle_timeout = 3600' }
  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match(/^trove_auth_url = http:\/\/localhost:5000\/v2.0$/) }
  its(:content) { should match '^nova_proxy_admin_user = admin$' }
  its(:content) { should match '^nova_proxy_admin_tenant_name=admin$' }
  its(:content) { should match '^nova_proxy_admin_pass = a_big_secret$' }
  its(:content) { should match '^rabbit_password=an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_userid=trove$' }
  its(:content) { should match '^rabbit_virtual_host=/$' }
  its(:content) { should match '^rabbit_use_ssl=False$' }
  its(:content) { should match '^amqp_durable_queues=False$' }
  its(:content) { should match '^rabbit_host=127.0.0.1$' }
  its(:content) { should match '^rabbit_port=5672$' }
  its(:content) { should match '^rabbit_password=an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_hosts=127.0.0.1:5672$' }
  its(:content) { should match '^rabbit_ha_queues=False$' }
  its(:content) { should match '^network_label_regex = .*$' }
  its(:content) { should match '^network_driver = trove.network.neutron.NeutronDriver$' }
  its(:content) { should match '^log_file = /var/log/trove/trove-taskmanager.log$' }
  its(:content) { should match '^log_dir = /var/log/trove$' }
  its(:content) { should match '^use_syslog=False$' }
  its(:content) { should match '^guest_config = /etc/trove/trove-guestagent.conf$' }
end

