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
    pp = <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      package { 'curl': ensure => present }

      class { '::memcached':
        listen_ip => '127.0.0.1',
      }

      # Swift resources
      class { '::swift':
        # not sure how I want to deal with this shared secret
        swift_hash_suffix => 'secrete',
        package_ensure    => latest,
      }
      class { '::swift::keystone::auth':
        password => 'a_big_secret',
      }
      # === Configure Storage
      class { '::swift::storage':
        storage_local_net_ip => '127.0.0.1',
      }
      # create xfs partitions on a loopback device and mounts them
      swift::storage::loopback { '2':
        require => Class['swift'],
      }
      # sets up storage nodes which is composed of a single
      # device that contains an endpoint for an object, account, and container
      swift::storage::node { '2':
        mnt_base_dir         => '/srv/node',
        weight               => 1,
        manage_ring          => true,
        zone                 => '2',
        storage_local_net_ip => '127.0.0.1',
        require              => Swift::Storage::Loopback[2] ,
      }
      class { '::swift::ringbuilder':
        part_power     => '18',
        replicas       => '1',
        min_part_hours => 1,
        require        => Class['swift'],
      }
      class { '::swift::proxy':
        proxy_local_net_ip => '127.0.0.1',
        pipeline           => ['healthcheck', 'cache', 'tempauth', 'dlo', 'proxy-server'],
        account_autocreate => true,
        require            => Class['swift::ringbuilder'],
      }
      class { '::swift::proxy::authtoken':
        admin_password => 'a_big_secret',
      }
      class {'::swift::objectexpirer':
        interval => 600,
      }
      class {
        [ '::swift::proxy::healthcheck', '::swift::proxy::cache',
        '::swift::proxy::tempauth', '::swift::proxy::dlo' ]:
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
    # Comment out the next to lines and uncomment the previous to run locally
    #apply_manifest(pp, :catch_failures => true, :modulepath => "/usr/share/openstack-puppet/modules")
    #apply_manifest(pp, :catch_changes => true, :modulepath => "/usr/share/openstack-puppet/modules")
  end
end


describe file('/etc/swift/swift.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
  its(:content) { should match '^swift_hash_path_suffix = secrete$' }
end

describe file('/etc/swift/object-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  its(:content) { should match 'pipeline = object-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6020' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = object-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  #its(:content) { should match 'object-replicator/concurrency' }
  #its(:content) { should match 'object-updater/concurrency' }
end

describe file('/etc/swift/container-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }
  its(:content) { should match 'pipeline = container-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6021' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = container-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  its(:content) { should match 'concurrency' }
  its(:content) { should match 'concurrency' }
end

describe file('/etc/swift/account-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  its(:content) { should match 'pipeline = account-server' }
  its(:content) { should match 'devices = /srv/node' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 6022' }
  its(:content) { should match 'mount_check = true' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = account-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL2' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }

  its(:content) { should match 'concurrency' }
  its(:content) { should match 'concurrency' }
end

describe file('/etc/swift/proxy-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'swift' }
  it { should be_grouped_into 'swift' }

  #its(:content) { should match 'pipeline:main/pipeline = healthcheck cache tempauth proxy-server' }
  its(:content) { should match 'bind_ip = 127.0.0.1' }
  its(:content) { should match 'bind_port = 8080' }
  its(:content) { should match 'user = swift' }
  its(:content) { should match 'workers' }
  its(:content) { should match 'log_name = proxy-server' }
  its(:content) { should match 'log_facility = LOG_LOCAL1' }
  its(:content) { should match 'log_level = INFO' }
  its(:content) { should match 'log_address = /dev/log' }
  its(:content) { should match 'log_handoffs = true' }
  its(:content) { should match 'allow_account_management = true' }
  its(:content) { should match 'account_autocreate = true' }
  its(:content) { should match 'user_admin_admin = admin .admin .reseller_admin' }
  its(:content) { should match 'log_name = swift' }
  its(:content) { should match 'signing_dir = /var/cache/swift' }
  its(:content) { should match 'paste.filter_factory = keystonemiddleware.auth_token:filter_factory' }
  its(:content) { should match 'auth_host = 127.0.0.1' }
  its(:content) { should match 'auth_port = 35357' }
  its(:content) { should match 'auth_protocol = http' }
  its(:content) { should match 'auth_uri = http://127.0.0.1:5000' }
  its(:content) { should match 'admin_tenant_name = services' }
  its(:content) { should match 'admin_user = swift' }
  its(:content) { should match 'admin_password = a_big_secret' }
  its(:content) { should match 'delay_auth_decision = 1' }
  its(:content) { should match 'cache = swift.cache' }
  its(:content) { should match 'include_service_catalog = False' }
  its(:content) { should match 'memcache_servers = 127.0.0.1:11211' }
end

