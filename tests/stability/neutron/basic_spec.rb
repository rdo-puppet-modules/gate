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

describe file('/etc/neutron') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/neutron/plugin.ini') do
  it { should be_symlink }
  it { should be_linked_to '/etc/neutron/plugins/ml2/ml2_conf.ini' }
end

describe file('/etc/neutron/neutron.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/neutron.conf') do
  let :service_plugins do
    [ 'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
      'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
      'neutron.services.metering.metering_plugin.MeteringPlugin' ]
  end

  its(:content) { should match '^verbose = True$' }
  its(:content) { should match '^debug = True$' }
  its(:content) { should match '^#bind_host = 0.0.0.0' }
  its(:content) { should match '^#bind_port = 9696' }
  its(:content) { should match 'auth_strategy = keystone' }
  its(:content) { should match 'core_plugin = ml2' }
  its(:content) { should match 'base_mac = fa:16:3e:00:00:00' }
  its(:content) { should match 'mac_generation_retries = 16' }
  its(:content) { should match 'dhcp_lease_duration = 86400' }
  its(:content) { should match 'dhcp_agents_per_network = 1' }
  its(:content) { should match 'dhcp_agent_notification = true' }
  its(:content) { should match 'allow_bulk = true' }
  its(:content) { should match 'allow_pagination = false' }
  its(:content) { should match 'allow_sorting = false' }
  its(:content) { should match 'allow_overlapping_ips = True' }
  its(:content) { should match 'control_exchange = neutron' }
  its(:content) { should match '^rpc_backend = rabbit$' }
  its(:content) { should match 'state_path = /var/lib/neutron' }
  #its(:content) { should match 'lock_path = /var/lib/neutron/lock' }
  its(:content) { should match 'root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf' }
  its(:content) { should match 'report_interval = 30' }
  its(:content) { should match 'log_dir = /var/log/neutron' }
  #its(:content) { should match 'service_plugins = service_plugins.join(","))' }
  its(:content) { should match 'rabbit_host = 127.0.0.1' }
  its(:content) { should match 'rabbit_port = 5672' }
  its(:content) { should match 'rabbit_hosts = 127.0.0.1:5672' }
  its(:content) { should match 'rabbit_ha_queues = false' }
  its(:content) { should match 'rabbit_userid = neutron' }
  its(:content) { should match 'rabbit_password = an_even_bigger_secret' }
  its(:content) { should match 'rabbit_virtual_host = /' }
  its(:content) { should match 'rabbit_use_ssl = false' }
  its(:content) { should match 'kombu_reconnect_delay = 1.0' }
  its(:content) { should match 'use_ssl = false' }
  its(:content) { should match 'api_workers' }
  its(:content) { should match 'rpc_workers' }
  its(:content) { should match 'agent_down_time = 75' }
  its(:content) { should match 'router_scheduler_driver = neutron.scheduler.l3_agent_scheduler.ChanceScheduler' }
  its(:content) { should match 'router_distributed = false' }
  its(:content) { should match 'allow_automatic_l3agent_failover = false' }
  its(:content) { should match(/connection = mysql\+pymysql:\/\/neutron:a_big_secret@127.0.0.1\/neutron\?charset=utf8/) }
  its(:content) { should match 'idle_timeout = 3600' }
  its(:content) { should match 'retry_interval = 10' }
  its(:content) { should match 'max_retries = 10' }
  its(:content) { should match '^#min_pool_size = 1$' }
  its(:content) { should match '^#max_pool_size = <None>$' }
  its(:content) { should match '^#max_overflow = <None>$' }
  its(:content) { should match 'admin_tenant_name=services' }
  its(:content) { should match 'admin_user=neutron' }
  its(:content) { should match 'admin_password=a_big_secret' }
  #its(:content) { should match 'auth_host = localhost' }
  #its(:content) { should match 'auth_port = 35357' }
  #its(:content) { should match 'auth_protocol = http' }
  its(:content) { should match 'auth_uri = http://localhost:5000/' }
  #its(:content) { should match 'notify_nova_on_port_status_changes = true' }
  #its(:content) { should match 'notify_nova_on_port_data_changes = true' }
  #its(:content) { should match 'send_events_interval = 2' }
  #its(:content) { should match 'nova_url = ' }
  #its(:content) { should match 'nova_admin_auth_url = ' }
  #its(:content) { should match 'nova_admin_username = nova' }
  #its(:content) { should match 'nova_admin_password = ' }
  #its(:content) { should match 'nova_region_name = RegionOne' }
end

describe file('/etc/neutron/api-paste.ini') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/neutron/api-paste.ini') do
  its(:content) { should match 'admin_tenant_name=services' }
  its(:content) { should match 'admin_user=neutron' }
  its(:content) { should match 'admin_password=a_big_secret' }
  #its(:content) { should match 'auth_host = localhost' }
  #its(:content) { should match 'auth_port = 35357' }
  #its(:content) { should match 'auth_protocol = http' }
  its(:content) { should match(/auth_uri=http:\/\/localhost:5000\//) }
end

describe file('/etc/neutron/plugins/ml2/ml2_conf.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/plugins/ml2/ml2_conf.ini') do
  its(:content) { should match 'type_drivers = vxlan' }
  its(:content) { should match 'tenant_network_types = vxlan' }
  its(:content) { should match 'mechanism_drivers =openvswitch,sriovnicswitch' }
  its(:content) { should match 'enable_security_group = true' }
  its(:content) { should match 'vxlan_group = 224.0.0.1' }
  its(:content) { should match 'vni_ranges =10:100' }
end

describe file('/etc/neutron/plugins/ml2/openvswitch_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
  its(:content) { should match '^#polling_interval = 2$' }
  its(:content) { should match '^#l2_population = false$' }
  its(:content) { should match '^#arp_responder = false$' }
  its(:content) { should match '^#enable_distributed_routing = false$' }
  its(:content) { should match 'integration_bridge = br-int$' }
  its(:content) { should match '^firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver$' }
  its(:content) { should match '^enable_tunneling=True$' }
  its(:content) { should match '^tunnel_bridge = br-tun$' }
  its(:content) { should match '^local_ip = 127.0.0.1$' }
  its(:content) { should match '^tunnel_types =vxlan$' }
  its(:content) { should match '^#vxlan_udp_port = 4789$' }
end

describe file('/etc/neutron/dhcp_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/dhcp_agent.ini') do
  its(:content) { should match 'debug = false' }
  its(:content) { should match 'state_path=/var/lib/neutron' }
  its(:content) { should match 'resync_interval = 30' }
  its(:content) { should match 'interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver' }
  its(:content) { should match 'dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq' }
  its(:content) { should match 'root_helper=sudo neutron-rootwrap /etc/neutron/rootwrap.conf' }
  its(:content) { should match 'dhcp_delete_namespaces=True' }
end

describe file('/etc/neutron/l3_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/l3_agent.ini') do
  its(:content) { should match 'debug = false' }
  its(:content) { should match 'external_network_bridge = br-ex' }
  its(:content) { should match 'interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver' }
  its(:content) { should match 'handle_internal_only_routers = true' }
  its(:content) { should match 'metadata_port = 9697' }
  its(:content) { should match 'send_arp_for_ha = 3' }
  its(:content) { should match 'periodic_interval = 40' }
  its(:content) { should match 'periodic_fuzzy_delay = 5' }
  its(:content) { should match 'enable_metadata_proxy = true' }
  its(:content) { should match 'router_delete_namespaces=True' }
  its(:content) { should match 'agent_mode = legacy' }
end

describe file('/etc/neutron/metering_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/metering_agent.ini') do
  its(:content) { should match 'debug = false' }
  its(:content) { should match 'interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver' }
  its(:content) { should match 'measure_interval = 30' }
  its(:content) { should match 'report_interval = 300' }
end

describe file('/etc/neutron/lbaas_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe file('/etc/neutron/lbaas_agent.ini') do
  its(:content) { should match 'debug = false' }
  its(:content) { should match 'interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver' }
  its(:content) { should match 'device_driver = neutron_lbaas.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver' }
  its(:content) { should match 'user_group = nobody' }
end

#describe file('/etc/neutron/metadata_agent.ini') do
#  it { should be_file }
#  it { should be_mode 640 }
#  it { should be_owned_by 'root' }
#  it { should be_grouped_into 'neutron' }
#end

#describe file('/etc/neutron/metadata_agent.ini') do
#  its(:content) { should match 'debug = false) }
#  its(:content) { should match 'auth_url = ) }
#  its(:content) { should match 'auth_insecure = false) }
#  its(:content) { should match 'auth_region = RegionOne') }
#  its(:content) { should match 'admin_tenant_name = services') }
#  its(:content) { should match 'admin_user = neutron') }
#  its(:content) { should match 'admin_password = ) }
#  its(:content) { should match 'nova_metadata_ip = ) }
#  its(:content) { should match 'nova_metadata_port = 8775) }
#  its(:content) { should match 'metadata_proxy_shared_secret = ) }
#  its(:content) { should match 'metadata_workers') }
#  its(:content) { should match 'metadata_backlog = 4096) }
#  its(:content) { should match 'cache_url = memory://?default_ttl=5') }
#end

#describe file('/etc/neutron/fwaas_driver.ini') do
#  it { should be_file }
#  it { should be_mode 640 }
#  it { should be_owned_by 'root' }
#  it { should be_grouped_into 'neutron' }
#end

#describe file('/etc/neutron/fwaas_driver.ini') do
#  its(:content) { should match 'enabled = true) }
#  its(:content) { should match 'driver = neutron.services.firewall.drivers.linux.iptables_fwaas.IptablesFwaasDriver') }
#end

describe file('/var/lib/neutron') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'neutron' }
  it { should be_grouped_into 'neutron' }
end
