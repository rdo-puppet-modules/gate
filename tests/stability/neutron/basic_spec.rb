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


describe file('/etc/neutron') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
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

describe config('/etc/neutron/neutron.conf') do
  let :service_plugins do
    [ 'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
      'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
      'neutron.services.metering.metering_plugin.MeteringPlugin' ]
  end

  it { should contain_setting('DEFAULT/verbose').with_value(false) }
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/bind_port').with_value(9696) }
  it { should contain_setting('DEFAULT/auth_strategy').with_value('keystone') }
  it { should contain_setting('DEFAULT/core_plugin').with_value('ml2') }
  it { should contain_setting('DEFAULT/base_mac').with_value('fa:16:3e:00:00:00') }
  it { should contain_setting('DEFAULT/mac_generation_retries').with_value(16) }
  it { should contain_setting('DEFAULT/dhcp_lease_duration').with_value(86400) }
  it { should contain_setting('DEFAULT/dhcp_agents_per_network').with_value(1) }
  it { should contain_setting('DEFAULT/dhcp_agent_notification').with_value(true) }
  it { should contain_setting('DEFAULT/allow_bulk').with_value(true) }
  it { should contain_setting('DEFAULT/allow_pagination').with_value(false) }
  it { should contain_setting('DEFAULT/allow_sorting').with_value(false) }
  it { should contain_setting('DEFAULT/allow_overlapping_ips').with_value(true) }
  it { should contain_setting('DEFAULT/control_exchange').with_value('neutron') }
  it { should contain_setting('DEFAULT/rpc_backend').with_value('neutron.openstack.common.rpc.impl_kombu') }
  it { should contain_setting('DEFAULT/state_path').with_value('/var/lib/neutron') }
  it { should contain_setting('DEFAULT/lock_path').with_value('/var/lib/neutron/lock') }
  it { should contain_setting('agent/root_helper').with_value('sudo neutron-rootwrap /etc/neutron/rootwrap.conf') }
  it { should contain_setting('agent/report_interval').with_value(30) }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/neutron') }
  it { should contain_setting('DEFAULT/service_plugins').with_value(service_plugins.join(',')) }
  it { should contain_setting('DEFAULT/rabbit_host').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/rabbit_port').with_value(5672) }
  it { should contain_setting('DEFAULT/rabbit_hosts').with_value('127.0.0.1:5672') }
  it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value(false) }
  it { should contain_setting('DEFAULT/rabbit_userid').with_value('neutron') }
  it { should contain_setting('DEFAULT/rabbit_password').with_value('an_even_bigger_secret') }
  it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_setting('DEFAULT/rabbit_use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/kombu_reconnect_delay').with_value(1.0) }
  it { should contain_setting('DEFAULT/use_ssl').with_value(false) }
  it { should contain_setting('DEFAULT/api_workers') }
  it { should contain_setting('DEFAULT/rpc_workers') }
  it { should contain_setting('DEFAULT/agent_down_time').with_value(75) }
  it { should contain_setting('DEFAULT/router_scheduler_driver').with_value('neutron.scheduler.l3_agent_scheduler.ChanceScheduler') }
  it { should contain_setting('DEFAULT/router_distributed').with_value(false) }
  it { should contain_setting('DEFAULT/allow_automatic_l3agent_failover').with_value(false) }
  it { should contain_setting('database/connection').with_value('mysql://neutron:a_big_secret@127.0.0.1/neutron?charset=utf8') }
  it { should contain_setting('database/idle_timeout').with_value(3600) }
  it { should contain_setting('database/retry_interval').with_value(10) }
  it { should contain_setting('database/max_retries').with_value(10) }
  it { should contain_setting('database/min_pool_size').with_value(1) }
  it { should contain_setting('database/max_pool_size').with_value(10) }
  it { should contain_setting('database/max_overflow').with_value(20) }
  it { should contain_setting('keystone_authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('keystone_authtoken/admin_user').with_value('neutron') }
  it { should contain_setting('keystone_authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('keystone_authtoken/auth_host').with_value('localhost') }
  it { should contain_setting('keystone_authtoken/auth_port').with_value(35357) }
  it { should contain_setting('keystone_authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('keystone_authtoken/auth_uri').with_value('http://localhost:5000/') }
  #it { should contain_setting('DEFAULT/notify_nova_on_port_status_changes').with_value(true) }
  #it { should contain_setting('DEFAULT/notify_nova_on_port_data_changes').with_value(true) }
  #it { should contain_setting('DEFAULT/send_events_interval').with_value(2) }
  #it { should contain_setting('DEFAULT/nova_url').with_value() }
  #it { should contain_setting('DEFAULT/nova_admin_auth_url').with_value() }
  #it { should contain_setting('DEFAULT/nova_admin_username').with_value('nova') }
  #it { should contain_setting('DEFAULT/nova_admin_password').with_value() }
  #it { should contain_setting('DEFAULT/nova_region_name').with_value('RegionOne') }
end

describe file('/etc/neutron/api-paste.ini') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe config('/etc/neutron/api-paste.ini') do
  it { should contain_setting('filter:authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('filter:authtoken/admin_user').with_value('neutron') }
  it { should contain_setting('filter:authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('filter:authtoken/auth_host').with_value('localhost') }
  it { should contain_setting('filter:authtoken/auth_port').with_value(35357) }
  it { should contain_setting('filter:authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('filter:authtoken/auth_uri').with_value('http://localhost:5000/') }
end

describe file('/etc/neutron/plugins/ml2/ml2_conf.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/plugins/ml2/ml2_conf.ini') do
  it { should contain_setting('ml2/type_drivers').with_value('vxlan') }
  it { should contain_setting('ml2/tenant_network_types').with_value('vxlan') }
  it { should contain_setting('ml2/mechanism_drivers').with_value('openvswitch') }
  it { should contain_setting('securitygroup/enable_security_group').with_value(true) }
  it { should contain_setting('ml2_type_vxlan/vxlan_group').with_value('224.0.0.1') }
  it { should contain_setting('ml2_type_vxlan/vni_ranges').with_value('10:100') }
end

describe file('/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini') do
  it { should contain_setting('agent/polling_interval').with_value(2) }
  it { should contain_setting('agent/l2_population').with_value(false) }
  it { should contain_setting('agent/arp_responder').with_value(false) }
  it { should contain_setting('agent/enable_distributed_routing').with_value(false) }
  it { should contain_setting('ovs/integration_bridge').with_value('br-int') }
  it { should contain_setting('securitygroup/firewall_driver').with_value('neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver') }
  it { should contain_setting('ovs/enable_tunneling').with_value(true) }
  it { should contain_setting('ovs/tunnel_bridge').with_value('br-tun') }
  it { should contain_setting('ovs/local_ip') }
  it { should contain_setting('agent/tunnel_types').with_value('vxlan') }
  it { should contain_setting('agent/vxlan_udp_port').with_value(4789) }
end

describe file('/etc/neutron/dhcp_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/dhcp_agent.ini') do
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/state_path').with_value('/var/lib/neutron') }
  it { should contain_setting('DEFAULT/resync_interval').with_value(30) }
  it { should contain_setting('DEFAULT/interface_driver').with_value('neutron.agent.linux.interface.OVSInterfaceDriver') }
  it { should contain_setting('DEFAULT/dhcp_driver').with_value('neutron.agent.linux.dhcp.Dnsmasq') }
  it { should contain_setting('DEFAULT/use_namespaces').with_value(true) }
  it { should contain_setting('DEFAULT/root_helper').with_value('sudo neutron-rootwrap /etc/neutron/rootwrap.conf') }
  it { should contain_setting('DEFAULT/dhcp_delete_namespaces').with_value(false) }
end

describe file('/etc/neutron/l3_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/l3_agent.ini') do
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/external_network_bridge').with_value('br-ex') }
  it { should contain_setting('DEFAULT/use_namespaces').with_value(true) }
  it { should contain_setting('DEFAULT/interface_driver').with_value('neutron.agent.linux.interface.OVSInterfaceDriver') }
  it { should contain_setting('DEFAULT/handle_internal_only_routers').with_value(true) }
  it { should contain_setting('DEFAULT/metadata_port').with_value(9697) }
  it { should contain_setting('DEFAULT/send_arp_for_ha').with_value(3) }
  it { should contain_setting('DEFAULT/periodic_interval').with_value(40) }
  it { should contain_setting('DEFAULT/periodic_fuzzy_delay').with_value(5) }
  it { should contain_setting('DEFAULT/enable_metadata_proxy').with_value(true) }
  it { should contain_setting('DEFAULT/router_delete_namespaces').with_value(false) }
  it { should contain_setting('DEFAULT/agent_mode').with_value('legacy') }
end

describe file('/etc/neutron/metering_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/metering_agent.ini') do
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/interface_driver').with_value('neutron.agent.linux.interface.OVSInterfaceDriver') }
  it { should contain_setting('DEFAULT/use_namespaces').with_value(true) }
  it { should contain_setting('DEFAULT/measure_interval').with_value(30) }
  it { should contain_setting('DEFAULT/report_interval').with_value(300) }
end

describe file('/etc/neutron/lbaas_agent.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'neutron' }
end

describe config('/etc/neutron/lbaas_agent.ini') do
  it { should contain_setting('DEFAULT/debug').with_value(false) }
  it { should contain_setting('DEFAULT/interface_driver').with_value('neutron.agent.linux.interface.OVSInterfaceDriver') }
  it { should contain_setting('DEFAULT/device_driver').with_value('neutron_lbaas.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver') }
  it { should contain_setting('DEFAULT/use_namespaces').with_value(true) }
  it { should contain_setting('haproxy/user_group').with_value('nobody') }
end

#describe file('/etc/neutron/metadata_agent.ini') do
#  it { should be_file }
#  it { should be_mode 640 }
#  it { should be_owned_by 'root' }
#  it { should be_grouped_into 'neutron' }
#end

#describe config('/etc/neutron/metadata_agent.ini') do
#  it { should contain_setting('DEFAULT/debug').with_value(false) }
#  it { should contain_setting('DEFAULT/auth_url').with_value() }
#  it { should contain_setting('DEFAULT/auth_insecure').with_value(false) }
#  it { should contain_setting('DEFAULT/auth_region').with_value('RegionOne') }
#  it { should contain_setting('DEFAULT/admin_tenant_name').with_value('services') }
#  it { should contain_setting('DEFAULT/admin_user').with_value('neutron') }
#  it { should contain_setting('DEFAULT/admin_password').with_value() }
#  it { should contain_setting('DEFAULT/nova_metadata_ip').with_value() }
#  it { should contain_setting('DEFAULT/nova_metadata_port').with_value(8775) }
#  it { should contain_setting('DEFAULT/metadata_proxy_shared_secret').with_value() }
#  it { should contain_setting('DEFAULT/metadata_workers') }
#  it { should contain_setting('DEFAULT/metadata_backlog').with_value(4096) }
#  it { should contain_setting('DEFAULT/cache_url').with_value('memory://?default_ttl=5') }
#end

#describe file('/etc/neutron/fwaas_driver.ini') do
#  it { should be_file }
#  it { should be_mode 640 }
#  it { should be_owned_by 'root' }
#  it { should be_grouped_into 'neutron' }
#end

#describe config('/etc/neutron/fwaas_driver.ini') do
#  it { should contain_setting('fwaas/enabled').with_value(true) }
#  it { should contain_setting('fwaas/driver').with_value('neutron.services.firewall.drivers.linux.iptables_fwaas.IptablesFwaasDriver') }
#end

describe file('/var/lib/neutron') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'neutron' }
  it { should be_grouped_into 'neutron' }
end
