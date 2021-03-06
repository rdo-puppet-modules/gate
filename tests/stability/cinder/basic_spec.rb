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

describe file('/etc/cinder/cinder.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'cinder' }
end

describe file('/etc/cinder/cinder.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'cinder' }
  its(:content) { should match '^rabbit_host = 127.0.0.1$' }
  its(:content) { should match '^rabbit_port = 5672$' }
  its(:content) { should match '^rabbit_hosts = 127.0.0.1:5672$' }
  its(:content) { should match '^rabbit_ha_queues = False$' }
  its(:content) { should match '^rabbit_password = an_even_bigger_secret$' }
  its(:content) { should match '^rabbit_userid = cinder$' }
  its(:content) { should match '^rabbit_virtual_host = /$' }
  its(:content) { should match '^rabbit_use_ssl = False$' }
  its(:content) { should match '^control_exchange = openstack$' }
  its(:content) { should match '^amqp_durable_queues = False$' }
  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match '^api_paste_config=/etc/cinder/api-paste.ini$' }
  its(:content) { should match '^rpc_backend = rabbit$' }
  its(:content) { should match '^storage_availability_zone = nova$' }
  its(:content) { should match '^default_availability_zone = nova$' }
  its(:content) { should match '^log_dir = /var/log/cinder$' }
  its(:content) { should match '^enable_v1_api = True$' }
  its(:content) { should match '^enable_v2_api = True$' }
  #its(:content) { should match 'connection = mysql+pymysql://cinder:a_big_secret@127.0.0.1/cinder?charset=utf8' }
  its(:content) { should match '^#idle_timeout = 3600$' }
  its(:content) { should match '^#min_pool_size = 1$' }
  its(:content) { should match '^#max_retries = 10$' }
  its(:content) { should match '^#retry_interval = 10$' }
  its(:content) { should match '^osapi_volume_listen = 0.0.0.0$' }
  its(:content) { should match '^osapi_volume_workers = 1$' }
  its(:content) { should match '^auth_strategy = keystone$' }
  #its(:content) { should match 'enabled_backends = lvm' }
  #its(:content) { should match 'volume_backend_name = lvm' }
  #its(:content) { should match 'volume_group = cinder-volumes' }
  #its(:content) { should match 'volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver' }
  #its(:content) { should match 'iscsi_ip_address = THING' }
  #its(:content) { should match 'iscsi_helper = lioadm' }
  #its(:content) { should match 'volumes_dir = /var/lib/cinder/volumes' }
  #its(:content) { should match 'iscsi_protocol = iscsi' }
end

describe file('/etc/cinder/api-paste.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'cinder' }
#  its(:content) { should match 'filter:authtoken/auth_uri = http://localhost:5000/' }
#  its(:content) { should match 'filter:authtoken/service_protocol = http' }
#  its(:content) { should match 'filter:authtoken/service_host = localhost' }
#  its(:content) { should match 'filter:authtoken/service_port = 5000' }
#  its(:content) { should match 'filter:authtoken/admin_tenant_name = services' }
#  its(:content) { should match 'filter:authtoken/admin_user = cinder' }
#  its(:content) { should match 'filter:authtoken/admin_password = property['puppet-cinder-keystone_password']) }
end
