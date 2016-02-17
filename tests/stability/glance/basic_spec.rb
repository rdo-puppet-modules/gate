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

describe file('/etc/glance/glance-api.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end

describe file('/etc/glance/glance-api.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
  #its(:content) { should match 'rabbit_host = ) }
  #its(:content) { should match 'rabbit_port = 5672) }
  #its(:content) { should match 'rabbit_hosts = ) }
  #its(:content) { should match 'rabbit_ha_queues = false) }
  #its(:content) { should match 'notification_driver = messaging') }
  #its(:content) { should match 'rabbit_virtual_host = /') }
  #its(:content) { should match 'rabbit_password = ) }
  #its(:content) { should match 'rabbit_userid = ) }
  #its(:content) { should match 'rabbit_notification_exchange = glance') }
  #its(:content) { should match 'rabbit_notification_topic = notifications') }
  #its(:content) { should match 'rabbit_use_ssl = false) }
  #its(:content) { should match 'amqp_durable_queues = false) }
  its(:content) { should match '^verbose=True$' }
  its(:content) { should match '^debug=False$' }
  its(:content) { should match '^bind_host=0.0.0.0$' }
  its(:content) { should match '^bind_port=9292$' }
  its(:content) { should match '^backlog=4096$' }
  its(:content) { should match '^workers=1$' }
  its(:content) { should match '^show_image_direct_url=False$' }
  its(:content) { should match '^image_cache_dir=/var/lib/glance/image-cache$' }
  its(:content) { should match '^os_region_name=RegionOne$' }
  its(:content) { should match '^registry_host=0.0.0.0$' }
  its(:content) { should match '^registry_port=9191$' }
  its(:content) { should match '^registry_client_protocol=http$' }
  its(:content) { should match '^auth_uri=http://127.0.0.1:5000/$' }
  its(:content) { should match '^#auth_host=127.0.0.1$' }
  its(:content) { should match '^#auth_port=35357$' }
  its(:content) { should match '^#auth_protocol=http$' }
  its(:content) { should match '^admin_tenant_name=services$' }
  its(:content) { should match '^admin_user=glance$' }
  its(:content) { should match '^admin_password=12345$' }
  its(:content) { should match '^flavor=keystone$' }
  its(:content) { should match '^log_file=/var/log/glance/api.log$' }
  its(:content) { should match '^log_dir=/var/log/glance$' }
  its(:content) { should match '^use_syslog=False$' }
  #its(:content) { should match 'default_store = file' }
  #its(:content) { should match 'filesystem_store_datadir = /var/lib/glance/images/' }
end

describe file('/etc/glance/glance-cache.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end

describe file('/etc/glance/glance-cache.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
  its(:content) { should match '^verbose=True$' }
  its(:content) { should match '^debug=False$' }
  its(:content) { should match '^os_region_name=RegionOne$' }
  its(:content) { should match '^registry_host=0.0.0.0$' }
  its(:content) { should match '^registry_port=9191$' }
  its(:content) { should match '^auth_url=http://127.0.0.1:5000/$' }
  its(:content) { should match '^admin_tenant_name=services$' }
  its(:content) { should match '^admin_user=glance$' }
  its(:content) { should match '^admin_password=12345$' }
  its(:content) { should match '^filesystem_store_datadir=/var/lib/glance/images/$' }
end

describe file('/etc/glance/glance-registry.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
  its(:content) { should match '^connection=mysql://glance:12345@127.0.0.1/glance$' }
  its(:content) { should match '^#idle_timeout=3600$' }
  its(:content) { should match '^verbose=True$' }
  its(:content) { should match '^debug=False$' }
  its(:content) { should match '^bind_host=0.0.0.0$' }
  its(:content) { should match '^bind_port=9191$' }
  its(:content) { should match '^auth_uri=http://127.0.0.1:5000/$' }
  its(:content) { should match '^#auth_host=127.0.0.1$' }
  its(:content) { should match '^#auth_port=35357$' }
  its(:content) { should match '^#auth_protocol=http$' }
  its(:content) { should match '^admin_tenant_name=services$' }
  its(:content) { should match '^admin_user=glance$' }
  its(:content) { should match '^admin_password=12345$' }
  its(:content) { should match '^flavor=keystone$' }
  its(:content) { should match '^log_file=/var/log/glance/registry.log$' }
  its(:content) { should match '^log_dir=/var/log/glance$' }
  its(:content) { should match '^use_syslog=False$' }
end

describe file('/etc/glance/glance-registry-paste.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'glance' }
end
