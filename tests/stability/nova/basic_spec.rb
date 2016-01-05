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
    pp=<<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'nova':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'nova@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Nova resources
      class { '::nova':
        database_connection => 'mysql+pymysql://nova:a_big_secret@127.0.0.1/nova?charset=utf8',
        rabbit_userid       => 'nova',
        rabbit_password     => 'an_even_bigger_secret',
        image_service       => 'nova.image.glance.GlanceImageService',
        glance_api_servers  => 'localhost:9292',
        verbose             => true,
        debug               => true,
        rabbit_host         => '127.0.0.1',
      }
      class { '::nova::db::mysql':
        password => 'a_big_secret',
      }
      class { '::nova::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::nova::api':
        admin_password => 'a_big_secret',
        identity_uri   => 'http://127.0.0.1:35357/',
        osapi_v3       => true,
      }
      class { '::nova::cert': }
      class { '::nova::client': }
      class { '::nova::conductor': }
      class { '::nova::consoleauth': }
      class { '::nova::cron::archive_deleted_rows': }
      class { '::nova::compute': vnc_enabled => true }
      class { '::nova::compute::libvirt':
        migration_support => true,
        vncserver_listen  => '0.0.0.0',
      }
      class { '::nova::scheduler': }
      class { '::nova::vncproxy': }
      # TODO: networking with neutron
	EOS

	# Uncomment to run locally
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
	# Uncomment to run in OPM-CI
    #apply_manifest(pp, :catch_failures => true, :modulepath => "/usr/share/openstack-puppet/modules")
    #apply_manifest(pp, :catch_changes => true, :modulepath => "/usr/share/openstack-puppet/modules")
  end
end

describe file('/etc/nova/nova.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'nova' }

  #its(:content) { should match 'image_service=nova.image.glance.GlanceImageService' }
  #its(:content) { should match 'api_servers=' }
  #its(:content) { should match 'auth_strategy=keystone' }
  #its(:content) { should match 'rabbit_password=' }
  #its(:content) { should match 'rabbit_userid=' }
  #its(:content) { should match 'rabbit_virtual_host=/' }
  #its(:content) { should match 'rabbit_use_ssl=false' }
  #its(:content) { should match 'amqp_durable_queues=false' }
  #its(:content) { should match 'rabbit_host=' }
  #its(:content) { should match 'rabbit_port=5672' }
  #its(:content) { should match 'rabbit_hosts=' }
  #its(:content) { should match 'rabbit_ha_queues=false' }
  its(:content) { should match 'log_dir=/var/log/nova' }
  its(:content) { should match 'verbose=True' }
  its(:content) { should match 'debug=false' }
  #its(:content) { should match 'rpc_backend=rabbit' }
  #its(:content) { should match 'notification_topics=notifications' }
  #its(:content) { should match 'notify_api_faults=false' }
  its(:content) { should match 'state_path=/var/lib/nova' }
  its(:content) { should match 'lock_path=/var/lib/nova/tmp' }
  its(:content) { should match 'service_down_time=60' }
  its(:content) { should match 'rootwrap_config=/etc/nova/rootwrap.conf' }
  its(:content) { should match 'report_interval=10' }
  its(:content) { should match 'se_syslog=false' }
  #its(:content) { should match 'os_region_name=RegionOne' }
  its(:content) { should match 'enabled_apis=osapi_compute,metadata' }
  its(:content) { should match 'volume_api_class=nova.volume.cinder.API' }
  its(:content) { should match 'osapi_compute_listen=0.0.0.0' }
  its(:content) { should match 'metadata_listen=0.0.0.0' }
  its(:content) { should match 'osapi_volume_listen=0.0.0.0' }
  its(:content) { should match 'osapi_compute_workers' }
  its(:content) { should match 'metadata_workers' }
  its(:content) { should match 'use_forwarded_for=false' }
  #its(:content) { should match '[osapi_v3]\nenabled=true' }
  its(:content) { should match 'auth_uri=http://127.0.0.1:5000/' }
  its(:content) { should match 'admin_tenant_name=services' }
  its(:content) { should match 'admin_user=nova' }
  its(:content) { should match 'admin_password=a_big_secret' }
  its(:content) { should match 'reserved_host_memory_mb=512' }
  its(:content) { should match 'compute_manager=nova.compute.manager.ComputeManager' }
  its(:content) { should match 'heal_instance_info_cache_interval=60' }
  its(:content) { should match 'novncproxy_base_url=http://127.0.0.1:6080/vnc_auto.html' }
  #its(:content) { should match 'vnc_enabled=True' }
  its(:content) { should match 'vncserver_proxyclient_address=127.0.0.1' }
  its(:content) { should match 'keymap=en-us' }
  its(:content) { should match 'force_raw_images=true' }
  its(:content) { should match 'default_availability_zone=nova' }
  its(:content) { should match 'internal_service_availability_zone=internal' }
  its(:content) { should match 'compute_driver=libvirt.LibvirtDriver' }
  its(:content) { should match 'vncserver_listen=0.0.0.0' }
  its(:content) { should match 'virt_type=kvm' }
  its(:content) { should match 'cpu_mode=host-model' }
  its(:content) { should match 'inject_password=False' }
  its(:content) { should match 'inject_key=False' }
  its(:content) { should match 'inject_partition=-2' }
  #its(:content) { should match 'dhcp_domain=novalocal' }
  #its(:content) { should match 'firewall_driver=nova.virt.firewall.NoopFirewallDriver' }
  #its(:content) { should match 'network_api_class=nova.network.neutronv2.api.API' }
  #its(:content) { should match 'security_group_api=neutron' }
  #its(:content) { should match 'vif_plugging_is_fatal=true' }
  #its(:content) { should match 'vif_plugging_timeout=300' }
  #its(:content) { should match 'auth_strategy=keystone' }
  #its(:content) { should match 'url=' }
  #its(:content) { should match 'url_timeout=30' }
  #its(:content) { should match 'admin_tenant_name=services' }
  #its(:content) { should match 'default_tenant_id=default' }
  #its(:content) { should match 'region_name=RegionOne' }
  #its(:content) { should match 'admin_username=neutron'' }
  #its(:content) { should match 'admin_password=' }
  #its(:content) { should match 'admin_auth_url=""' }
  #its(:content) { should match 'ovs_bridge=br-int' }
  #its(:content) { should match 'extension_sync_interval=600' }
  #its(:content) { should match 'vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver' }
  #its(:content) { should match 'force_snat_range=0.0.0.0/0' }
  its(:content) { should match 'novncproxy_host=0.0.0.0' }
  its(:content) { should match 'novncproxy_port=6080' }
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
  it { should be_grouped_into 'root' }
end
