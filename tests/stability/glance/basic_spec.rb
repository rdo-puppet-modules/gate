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


describe file('/etc/glance/glance-api.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end

describe config('/etc/glance/glance-api.conf') do
  #it { should contain_setting('DEFAULT/rabbit_host').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  #it { should contain_setting('DEFAULT/rabbit_hosts').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  #it { should contain_setting('DEFAULT/notification_driver').with_value('messaging') }
  #it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  #it { should contain_setting('DEFAULT/rabbit_password').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_userid').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_notification_exchange').with_value('glance') }
  #it { should contain_setting('DEFAULT/rabbit_notification_topic').with_value('notifications') }
  #it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  #it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/bind_port').with_value(9292) }
  it { should contain_setting('DEFAULT/backlog').with_value(4096) }
  it { should contain_setting('DEFAULT/workers') }
  it { should contain_setting('DEFAULT/show_image_direct_url').with_value(false) }
  it { should contain_setting('DEFAULT/image_cache_dir').with_value('/var/lib/glance/image-cache') }
  it { should contain_setting('DEFAULT/os_region_name').with_value('RegionOne') }
  it { should contain_setting('DEFAULT/registry_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/registry_port').with_value(9191) }
  it { should contain_setting('DEFAULT/registry_client_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/') }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('glance') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('paste_deploy/flavor').with_value('keystone') }
  it { should contain_setting('DEFAULT/log_file').with_value('/var/log/glance/api.log') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/glance') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  #it { should contain_setting('glance_store/default_store').with_value('file') }
  #it { should contain_setting('glance_store/filesystem_store_datadir').with_value('/var/lib/glance/images/') }
end

#describe file('/etc/glance/glance-cache.conf') do
#  it { should be_file }
#  it { should be_mode 640 }
#  it { should be_owned_by 'glance' }
#  it { should be_grouped_into 'glance' }
#end

#describe config('/etc/glance/glance-cache.conf') do
#  it { should contain_setting('DEFAULT/verbose').with_value(false) }
#  it { should contain_setting('DEFAULT/debug').with_value(false) }
#  it { should contain_setting('DEFAULT/os_region_name').with_value('RegionOne') }
#  it { should contain_setting('DEFAULT/registry_host').with_value('0.0.0.0') }
#  it { should contain_setting('DEFAULT/registry_port').with_value(9191) }
#  it { should contain_setting('DEFAULT/auth_url').with_value('http://localhost:5000/v2.0') }
#  it { should contain_setting('DEFAULT/admin_tenant_name').with_value('services') }
#  it { should contain_setting('DEFAULT/admin_user').with_value('glance') }
#  it { should contain_setting('DEFAULT/admin_password').with_value('a_big_secret') }
#  it { should contain_setting('glance_store/filesystem_store_datadir').with_value('/var/lib/glance/images/') }
#end

describe file('/etc/glance/glance-registry.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end

describe config('/etc/glance/glance-registry.conf') do
  it { should contain_setting('database/connection').with_value('mysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8') }
  it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/bind_port').with_value(9191) }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/') }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('glance') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('paste_deploy/flavor').with_value('keystone') }
  it { should contain_setting('DEFAULT/log_file').with_value('/var/log/glance/registry.log') }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/glance') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
end

describe file('/etc/glance/glance-registry-paste.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end
