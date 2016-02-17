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

describe file('/etc/ceilometer/') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/ceilometer/policy.json') do
  it { should be_file }
end

describe file('/etc/ceilometer/ceilometer.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'ceilometer' }
#  its(:content) { should match 'connection = mysql://ceilometer:a_big_secret@127.0.0.1/ceilometer?charset=utf8' }
  its(:content) { should match '^#connection =' }
  its(:content) { should match '^rabbit_host = 127.0.0.1$' }
  its(:content) { should match '^rabbit_port = 5672$' }
  its(:content) { should match '^rabbit_hosts = 127.0.0.1:5672$' }
  its(:content) { should match '^rabbit_userid = ceilometer$' }
  its(:content) { should match '^rabbit_password = an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_virtual_host = /$' }
  its(:content) { should match '^#rabbit_use_ssl = false$' }
  its(:content) { should match '^rpc_backend = rabbit$' }
  its(:content) { should match '^metering_secret=secrete$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^notification_topics = notifications$' }
  its(:content) { should match '^log_dir = /var/log/ceilometer$' }
  #its(:content) { should match 'os_auth_url = localhost:35357/v2.0') }
  #its(:content) { should match 'os_region_name = RegionOne') }
  #its(:content) { should match 'os_username = ceilometer') }
  #its(:content) { should match 'os_password = a_big_secret') }
  #its(:content) { should match 'os_tenant_name = services') }
  #its(:content) { should match 'backend_url = ) }
  its(:content) { should match '^evaluation_interval = 60$' }
  its(:content) { should match '^evaluation_service=ceilometer.alarm.service.SingletonAlarmService$' }
  its(:content) { should match '^partition_rpc_topic=alarm_partition_coordination$' }
  its(:content) { should match '^#record_history = true$' }
  its(:content) { should match '^admin_tenant_name = services$' }
  its(:content) { should match '^admin_user = ceilometer$' }
  its(:content) { should match '^host = 0.0.0.0$' }
  its(:content) { should match '^port = 8777$' }
  its(:content) { should match '^#auth_host = 127.0.0.1$' }
  its(:content) { should match '^#auth_port = 35357$' }
  its(:content) { should match '^#auth_protocol = https$' }
  its(:content) { should match '^admin_password = a_big_secret$' }
  its(:content) { should match '^auth_uri = http://127.0.0.1:5000/$' }
  its(:content) { should match '^udp_address = 0.0.0.0$' }
  its(:content) { should match '^udp_port = 4952$' }
  its(:content) { should match '^#ack_on_event_error = true$' }
  its(:content) { should match '^#store_events = false$' }
end
