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


describe file('/etc/sahara/sahara.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'sahara' }
end

describe config('/etc/sahara/sahara.conf') do
  it { should contain_setting('DEFAULT/use_neutron').with_value(false) }
  it { should contain_setting('DEFAULT/use_floating_ips').with_value(true) }
  it { should contain_setting('DEFAULT/host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/port').with_value(8386) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('database/connection').with_value('mysql://sahara:a_big_secret@127.0.0.1/sahara?charset=utf8') }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0/') }
  it { should contain_setting('keystone_authtoken/identity_uri').with_value('http://127.0.0.1:35357/') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('admin') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('admin') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/sahara') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  # Due to bug in module this is not set correctly
  #it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('rabbit') }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('sahara') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_login_method').with_value('AMQPLAIN') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_retry_interval').with_value(1) }
  it { should contain_setting('DEFAULT/rabbit_retry_backoff').with_value(2) }
  it { should contain_setting('DEFAULT/rabbit_max_retries').with_value(0) }
  it { should contain_setting('DEFAULT/notification_topics').with_value('notifications') }
  it { should contain_setting('DEFAULT/control_exchange').with_value('openstack') }
  it { should contain_setting('DEFAULT/kombu_reconnect_delay').with_value(1.0) }
end


