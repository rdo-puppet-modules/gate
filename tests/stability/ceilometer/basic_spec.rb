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

describe file('/etc/ceilometer/') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'ceilometer' }
  it { should be_grouped_into 'ceilometer' }
end

describe file('/etc/ceilometer/policy.json') do
  it { should be_file }
end

describe file('/etc/ceilometer/ceilometer.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'ceilometer' }
  it { should be_grouped_into 'ceilometer' }
end

describe config('/etc/ceilometer/ceilometer.conf') do
  it { should contain_setting('database/connection').with_value('mysql://ceilometer:a_big_secret@127.0.0.1/ceilometer?charset=utf8') }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('ceilometer') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('ceilometer.openstack.common.rpc.impl_kombu') }
  it { should contain_setting('publisher/metering_secret').with_value('secrete') }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/notification_topics').with_value('notifications') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/ceilometer') }
  #it { should contain_setting('service_credentials/os_auth_url').with_value('localhost:35357/v2.0') }
  #it { should contain_setting('service_credentials/os_region_name').with_value('RegionOne') }
  #it { should contain_setting('service_credentials/os_username').with_value('ceilometer') }
  #it { should contain_setting('service_credentials/os_password').with_value('a_big_secret') }
  #it { should contain_setting('service_credentials/os_tenant_name').with_value('services') }
  #it { should contain_setting('coordination/backend_url').with_value() }
  it { should contain_setting('alarm/evaluation_interval').with_value(60) }
  it { should contain_setting('alarm/evaluation_service').with_value('ceilometer.alarm.service.SingletonAlarmService') }
  it { should contain_setting('alarm/partition_rpc_topic').with_value('alarm_partition_coordination') }
  it { should contain_setting('alarm/record_history').with_value(true) }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('ceilometer') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value(property['puppet-ceilometer-keystone_password']) }
  it { should contain_setting('api/host').with_value('0.0.0.0') }
  it { should contain_setting('api/port').with_value(8777) }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/') }
  it { should contain_setting('collector/udp_address').with_value('0.0.0.0') }
  it { should contain_setting('collector/udp_port').with_value(4952) }
  it { should contain_setting('notification/ack_on_event_error').with_value(true) }
  it { should contain_setting('notification/store_events').with_value(false) }
end
