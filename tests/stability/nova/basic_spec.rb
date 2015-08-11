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


describe file('/etc/nova/nova.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'nova' }
  it { should be_grouped_into 'nova' }
end

describe config('/etc/nova/nova.conf') do
  #it { should contain_setting('DEFAULT/image_service').with_value('nova.image.glance.GlanceImageService') }
  #it { should contain_setting('glance/api_servers').with_value() }
  #it { should contain_setting('DEFAULT/auth_strategy').with_value('keystone') }
  #it { should contain_setting('DEFAULT/rabbit_password').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_userid').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  #it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  #it { should contain_setting('DEFAULT/amqp_durable_queues').with_value(false) }
  #it { should contain_setting('DEFAULT/rabbit_host').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  #it { should contain_setting('DEFAULT/rabbit_hosts').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/nova') }
  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  #it { should contain_setting('DEFAULT/rpc_backend').with_value('rabbit') }
  #it { should contain_setting('DEFAULT/notification_topics').with_value('notifications') }
  #it { should contain_setting('DEFAULT/notify_api_faults').with_value(false) }
  it { should contain_setting('DEFAULT/state_path').with_value('/var/lib/nova') }
  it { should contain_setting('DEFAULT/lock_path').with_value('/var/lib/nova/tmp') }
  it { should contain_setting('DEFAULT/service_down_time').with_value(60) }
  it { should contain_setting('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf') }
  it { should contain_setting('DEFAULT/report_interval').with_value(10) }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  #it { should contain_setting('DEFAULT/os_region_name').with_value('RegionOne') }
  it { should contain_setting('DEFAULT/enabled_apis').with_value('ec2,osapi_compute,metadata') }
  it { should contain_setting('DEFAULT/volume_api_class').with_value('nova.volume.cinder.API') }
  it { should contain_setting('DEFAULT/ec2_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/osapi_compute_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/metadata_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/osapi_volume_listen').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/osapi_compute_workers') }
  it { should contain_setting('DEFAULT/ec2_workers') }
  it { should contain_setting('DEFAULT/metadata_workers') }
  it { should contain_setting('DEFAULT/use_forwarded_for').with_value(false) }
  it { should contain_setting('osapi_v3/enabled').with_value(true) }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/') }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('nova') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('DEFAULT/reserved_host_memory_mb').with_value(512) }
  it { should contain_setting('DEFAULT/compute_manager').with_value('nova.compute.manager.ComputeManager') }
  it { should contain_setting('DEFAULT/heal_instance_info_cache_interval').with_value(60) }
  it { should contain_setting('DEFAULT/novncproxy_base_url').with_value('http://0.0.0.0:6080/vnc_auto.html') }
  it { should contain_setting('DEFAULT/vnc_enabled').with_value(true) }
  it { should contain_setting('DEFAULT/vncserver_proxyclient_address').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/vnc_keymap').with_value('en-us') }
  it { should contain_setting('DEFAULT/force_raw_images').with_value(true) }
  it { should contain_setting('DEFAULT/default_availability_zone').with_value('nova') }
  it { should contain_setting('DEFAULT/internal_service_availability_zone').with_value('internal') }
  it { should contain_setting('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver') }
  it { should contain_setting('DEFAULT/vncserver_listen').with_value('0.0.0.0') }
  it { should contain_setting('libvirt/virt_type').with_value('kvm') }
  it { should contain_setting('libvirt/cpu_mode').with_value('host-model') }
  it { should contain_setting('libvirt/inject_password').with_value(false) }
  it { should contain_setting('libvirt/inject_key').with_value(false) }
  it { should contain_setting('libvirt/inject_partition').with_value(-2) }
  #it { should contain_setting('DEFAULT/dhcp_domain').with_value('novalocal') }
  #it { should contain_setting('DEFAULT/firewall_driver').with_value('nova.virt.firewall.NoopFirewallDriver') }
  #it { should contain_setting('DEFAULT/network_api_class').with_value('nova.network.neutronv2.api.API') }
  #it { should contain_setting('DEFAULT/security_group_api').with_value('neutron') }
  #it { should contain_setting('DEFAULT/vif_plugging_is_fatal').with_value(true) }
  #it { should contain_setting('DEFAULT/vif_plugging_timeout').with_value(300) }
  #it { should contain_setting('neutron/auth_strategy').with_value('keystone') }
  #it { should contain_setting('neutron/url').with_value() }
  #it { should contain_setting('neutron/url_timeout').with_value(30) }
  #it { should contain_setting('neutron/admin_tenant_name').with_value('services') }
  #it { should contain_setting('neutron/default_tenant_id').with_value('default') }
  #it { should contain_setting('neutron/region_name').with_value('RegionOne') }
  #it { should contain_setting('neutron/admin_username').with_value('neutron') }
  #it { should contain_setting('neutron/admin_password').with_value() }
  #it { should contain_setting('neutron/admin_auth_url').with_value("") }
  #it { should contain_setting('neutron/ovs_bridge').with_value('br-int') }
  #it { should contain_setting('neutron/extension_sync_interval').with_value(600) }
  #it { should contain_setting('libvirt/vif_driver').with_value('nova.virt.libvirt.vif.LibvirtGenericVIFDriver') }
  #it { should contain_setting('DEFAULT/force_snat_range').with_value('0.0.0.0/0') }
  it { should contain_setting('DEFAULT/novncproxy_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/novncproxy_port').with_value(6080) }
end

describe file('/var/lib/nova') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'nova' }
  it { should be_grouped_into 'nova' }
end

describe file('/var/log/nova') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'nova' }
  it { should be_grouped_into 'nova' }
end
