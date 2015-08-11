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


describe file('/etc/cinder/cinder.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'cinder' }
  it { should be_grouped_into 'cinder' }
end

describe config('/etc/cinder/cinder.conf') do
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('cinder') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/control_exchange').with_value('openstack') }
  it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/api_paste_config').with_value('/etc/cinder/api-paste.ini') }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('cinder.openstack.common.rpc.impl_kombu') }
  it { should contain_setting('DEFAULT/storage_availability_zone').with_value('nova') }
  it { should contain_setting('DEFAULT/default_availability_zone').with_value('nova') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/cinder') }
  it { should contain_setting('DEFAULT/enable_v1_api').with_value(true) }
  it { should contain_setting('DEFAULT/enable_v2_api').with_value(true) }
  it { should contain_setting('database/connection').with_value('mysql://cinder:a_big_secret@127.0.0.1/cinder?charset=utf8') }
  it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('database/min_pool_size').with_value(1) }
  it { should contain_setting('database/max_retries').with_value(10) }
  it { should contain_setting('database/retry_interval').with_value(10) }
  it { should contain_setting('DEFAULT/osapi_volume_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/osapi_volume_workers') }
  it { should contain_setting('DEFAULT/auth_strategy').with_value('keystone') }
  #it { should contain_setting('DEFAULT/enabled_backends').with_value('lvm') }
  #it { should contain_setting('lvm/volume_backend_name').with_value('lvm') }
  #it { should contain_setting('lvm/volume_group').with_value('cinder-volumes') }
  #it { should contain_setting('lvm/volume_driver').with_value('cinder.volume.drivers.lvm.LVMVolumeDriver') }
  #it { should contain_setting('lvm/iscsi_ip_address').with_value(property['puppet-cinder-iscsi_ip_address']) }
  #it { should contain_setting('lvm/iscsi_helper').with_value('lioadm') }
  #it { should contain_setting('lvm/volumes_dir').with_value('/var/lib/cinder/volumes') }
  #it { should contain_setting('lvm/iscsi_protocol').with_value('iscsi') }
end

describe file('/etc/cinder/api-paste.ini') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'cinder' }
  it { should be_grouped_into 'cinder' }
end

describe config('/etc/cinder/api-paste.ini') do
  it { should contain_setting('filter:authtoken/auth_uri').with_value('http://localhost:5000/') }
  it { should contain_setting('filter:authtoken/service_protocol').with_value('http') }
  it { should contain_setting('filter:authtoken/service_host').with_value('localhost') }
  it { should contain_setting('filter:authtoken/service_port').with_value(5000) }
  it { should contain_setting('filter:authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('filter:authtoken/admin_user').with_value('cinder') }
  it { should contain_setting('filter:authtoken/admin_password').with_value(property['puppet-cinder-keystone_password']) }
end
