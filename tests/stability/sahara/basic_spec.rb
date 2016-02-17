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

describe file('/etc/sahara/sahara.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'sahara' }

  its(:content) { should match '^#use_neutron = false$' }
  its(:content) { should match '^#use_floating_ips = true$' }
  #its(:content) { should match 'host = 0.0.0.0' }
  its(:content) { should match '^#port = 8386$' }
  its(:content) { should match '^#debug = false$' }
  its(:content) { should match '^#verbose = true$' }
  its(:content) { should match(/^connection = mysql\+pymysql:\/\/sahara:a_big_secret@127.0.0.1\/sahara\?charset=utf8$/) }
  its(:content) { should match '^auth_uri = http://127.0.0.1:5000/v2.0/$' }
  its(:content) { should match(/^identity_uri=http:\/\/127.0.0.1:35357\/$/) }
  its(:content) { should match '^admin_tenant_name=services$' }
  its(:content) { should match '^admin_password=a_big_secret$' }
  its(:content) { should match '^admin_user=sahara$' }
  its(:content) { should match '^log_dir = /var/log/sahara$' }
  its(:content) { should match '^#use_syslog = false$' }
  its(:content) { should match '^rabbit_host = 127.0.0.1$' }
  its(:content) { should match '^#rabbit_port = 5672$' }
  its(:content) { should match '^#rabbit_ha_queues = false$' }
  its(:content) { should match '^#rabbit_hosts = \$rabbit_host:\$rabbit_port' }
  its(:content) { should match '^rpc_backend = rabbit$' }
  its(:content) { should match '^#amqp_durable_queues = false$' }
  its(:content) { should match '^#rabbit_use_ssl = false$' }
  its(:content) { should match '^rabbit_userid = sahara$' }
  its(:content) { should match '^rabbit_password = an_even_bigger_secret$' }
  its(:content) { should match '^#rabbit_login_method = AMQPLAIN$' }
  its(:content) { should match '^#rabbit_virtual_host = /$' }
  its(:content) { should match '^#rabbit_retry_interval = 1$' }
  its(:content) { should match '^#rabbit_retry_backoff = 2$' }
  its(:content) { should match '^#rabbit_max_retries = 0$' }
  its(:content) { should match '^#topics = notifications$' }
  its(:content) { should match '^#control_exchange = openstack$' }
  its(:content) { should match '^#kombu_reconnect_delay = 1.0$' }
end


