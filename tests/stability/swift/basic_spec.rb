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


describe file('/etc/swift/swift.conf') do
  it { should be_file }
  it { should be_mode 660 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
end

describe config('/etc/swift/swift.conf') do
  it { should contain_setting('swift-hash/swift_hash_path_suffix').with_value('secrete') }
end

describe file('/etc/swift/object-server.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
end

describe config('/etc/swift/object-server.conf') do
  it { should contain_setting('pipeline:main/pipeline').with_value('object-server') }
  it { should contain_setting('DEFAULT/devices').with_value('/srv/node') }
  it { should contain_setting('DEFAULT/bind_ip').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/bind_port').with_value(6020) }
  it { should contain_setting('DEFAULT/mount_check').with_value(false) }
  it { should contain_setting('DEFAULT/user').with_value('swift') }
  it { should contain_setting('DEFAULT/workers') }
  it { should contain_setting('DEFAULT/log_name').with_value('object-server') }
  it { should contain_setting('DEFAULT/log_facility').with_value('LOG_LOCAL2') }
  it { should contain_setting('DEFAULT/log_level').with_value('INFO') }
  it { should contain_setting('DEFAULT/log_address').with_value('/dev/log') }

  it { should contain_setting('object-replicator/concurrency') }
  it { should contain_setting('object-updater/concurrency') }
end

describe file('/etc/swift/container-server.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
end

describe config('/etc/swift/container-server.conf') do
  it { should contain_setting('pipeline:main/pipeline').with_value('container-server') }
  it { should contain_setting('DEFAULT/devices').with_value('/srv/node') }
  it { should contain_setting('DEFAULT/bind_ip').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/bind_port').with_value(6021) }
  it { should contain_setting('DEFAULT/mount_check').with_value(false) }
  it { should contain_setting('DEFAULT/user').with_value('swift') }
  it { should contain_setting('DEFAULT/workers') }
  it { should contain_setting('DEFAULT/log_name').with_value('container-server') }
  it { should contain_setting('DEFAULT/log_facility').with_value('LOG_LOCAL2') }
  it { should contain_setting('DEFAULT/log_level').with_value('INFO') }
  it { should contain_setting('DEFAULT/log_address').with_value('/dev/log') }

  it { should contain_setting('container-replicator/concurrency') }
  it { should contain_setting('container-updater/concurrency') }
end

describe file('/etc/swift/account-server.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
end

describe config('/etc/swift/account-server.conf') do
  it { should contain_setting('pipeline:main/pipeline').with_value('account-server') }
  it { should contain_setting('DEFAULT/devices').with_value('/srv/node') }
  it { should contain_setting('DEFAULT/bind_ip').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/bind_port').with_value(6022) }
  it { should contain_setting('DEFAULT/mount_check').with_value(false) }
  it { should contain_setting('DEFAULT/user').with_value('swift') }
  it { should contain_setting('DEFAULT/workers') }
  it { should contain_setting('DEFAULT/log_name').with_value('account-server') }
  it { should contain_setting('DEFAULT/log_facility').with_value('LOG_LOCAL2') }
  it { should contain_setting('DEFAULT/log_level').with_value('INFO') }
  it { should contain_setting('DEFAULT/log_address').with_value('/dev/log') }

  it { should contain_setting('account-replicator/concurrency') }
  it { should contain_setting('account-reaper/concurrency') }
end

describe file('/etc/swift/proxy-server.conf') do
  it { should be_file }
  it { should be_mode 660 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
end

describe config('/etc/swift/proxy-server.conf') do
  it { should contain_setting('pipeline:main/pipeline').with_value('healthcheck cache tempauth proxy-server') }
  it { should contain_setting('DEFAULT/bind_ip').with_value('127.0.0.1') }
  it { should contain_setting('DEFAULT/bind_port').with_value(8080) }
  it { should contain_setting('DEFAULT/user').with_value('swift') }
  it { should contain_setting('DEFAULT/workers') }
  it { should contain_setting('DEFAULT/log_name').with_value('proxy-server') }
  it { should contain_setting('DEFAULT/log_facility').with_value('LOG_LOCAL1') }
  it { should contain_setting('DEFAULT/log_level').with_value('INFO') }
  it { should contain_setting('DEFAULT/log_address').with_value('/dev/log') }
  it { should contain_setting('app:proxy-server/log_handoffs').with_value(true) }
  it { should contain_setting('app:proxy-server/allow_account_management').with_value(true) }
  it { should contain_setting('app:proxy-server/account_autocreate').with_value(true) }
  it { should contain_setting('filter:tempauth/user_admin_admin').with_value('admin .admin .reseller_admin') }
  it { should contain_setting('filter:authtoken/log_name').with_value('swift') }
  it { should contain_setting('filter:authtoken/signing_dir').with_value('/var/cache/swift') }
  it { should contain_setting('filter:authtoken/paste.filter_factory').with_value('keystonemiddleware.auth_token:filter_factory') }
  it { should contain_setting('filter:authtoken/auth_host').with_value('127.0.0.1') }
  it { should contain_setting('filter:authtoken/auth_port').with_value(35357) }
  it { should contain_setting('filter:authtoken/auth_protocol').with_value('http') }
  it { should contain_setting('filter:authtoken/auth_uri').with_value('http://127.0.0.1:5000') }
  it { should contain_setting('filter:authtoken/admin_tenant_name').with_value('services') }
  it { should contain_setting('filter:authtoken/admin_user').with_value('swift') }
  it { should contain_setting('filter:authtoken/admin_password').with_value('a_big_secret') }
  it { should contain_setting('filter:authtoken/delay_auth_decision').with_value(1) }
  it { should contain_setting('filter:authtoken/cache').with_value('swift.cache') }
  it { should contain_setting('filter:authtoken/include_service_catalog').with_value(false) }
  it { should contain_setting('filter:cache/memcache_servers').with_value('127.0.0.1:11211') }
end

