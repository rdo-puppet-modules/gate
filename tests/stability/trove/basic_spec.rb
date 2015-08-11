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


describe file('/etc/trove') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'trove' }
end

describe config('/etc/trove/trove.conf') do
  it { should contain_setting('database/connection').with_value('mysql://trove:a_big_secret@127.0.0.1/trove?charset=utf8') }
  #TODO: due to bug in module this is not set correctly 
  #it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/bind_port').with_value(8779) }
  it { should contain_setting('DEFAULT/backlog').with_value(4096) }
  it { should contain_setting('DEFAULT/trove_api_workers') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_user').with_value('admin') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_pass').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_tenant_name').with_value('admin') }
  it { should contain_setting('DEFAULT/control_exchange').with_value('trove') }
  it { should contain_setting('DEFAULT/trove_auth_url').with_value('http://127.0.0.1:35357/') }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('trove') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/log_file').with_value('/var/log/trove/trove-api.log') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/trove') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('trove') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/network_label_regex').with_value('.*') }
  it { should contain_setting('DEFAULT/network_driver').with_value('trove.network.neutron.NeutronDriver') }
  it { should contain_setting('DEFAULT/taskmanager_queue').with_value('taskmanager') }
end

describe config('/etc/trove/trove-conductor.conf') do
  it { should contain_setting('database/connection').with_value('mysql://trove:a_big_secret@127.0.0.1/trove?charset=utf8') }
  #TODO: due to bug in module this is not set correctly
  #it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/trove_auth_url').with_value('http://localhost:5000/v2.0') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_user').with_value('admin') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_tenant_name').with_value('admin') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_pass').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/control_exchange').with_value('trove') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('trove') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_notification_topic').with_value('notifications') }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/log_file').with_value('/var/log/trove/trove-conductor.log') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/trove') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
end

describe config('/etc/trove/trove-taskmanager.conf') do
  it { should contain_setting('database/connection').with_value('mysql://trove:a_big_secret@127.0.0.1/trove?charset=utf8') }
  #TODO: due to bug in module this is not set correctly
  #it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/trove_auth_url').with_value('http://localhost:5000/v2.0') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_user').with_value('admin') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_tenant_name').with_value('admin') }
  it { should contain_setting('DEFAULT/nova_proxy_admin_pass').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('trove') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/network_label_regex').with_value('.*') }
  it { should contain_setting('DEFAULT/network_driver').with_value('trove.network.neutron.NeutronDriver') }
  it { should contain_setting('DEFAULT/log_file').with_value('/var/log/trove/trove-taskmanager.log') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/trove') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('DEFAULT/guest_config').with_value('/etc/trove/trove-guestmanager.conf') }
end

