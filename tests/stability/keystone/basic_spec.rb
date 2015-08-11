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


describe file('/etc/keystone') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'keystone' }
  it { should be_grouped_into 'keystone' }
end

describe file('/var/log/keystone') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'keystone' }
  it { should be_grouped_into 'keystone' }
end

describe file('/var/lib/keystone') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'keystone' }
  it { should be_grouped_into 'keystone' }
end

describe file('/var/cache/keystone') do
  it { should be_directory }
end

describe file('/etc/keystone/keystone.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'keystone' }
  it { should be_grouped_into 'keystone' }
end

describe config('/etc/keystone/keystone.conf') do
  it { should contain_setting('DEFAULT/admin_token').with_value('admin_token') }
  it { should contain_setting('DEFAULT/public_bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/admin_bind_host').with_value('0.0.0.0') }
  it { should contain_setting('DEFAULT/public_port').with_value(5000) }
  it { should contain_setting('DEFAULT/admin_port').with_value(35357) }
  it { should contain_setting('DEFAULT/verbose').with_value(true) }
  it { should contain_setting('DEFAULT/debug').with_value(true) }
  #it { should contain_setting('DEFAULT/rabbit_password').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_userid').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_virtual_host').with_value('/') }
  #it { should contain_setting('DEFAULT/rabbit_host').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_port').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_hosts').with_value() }
  #it { should contain_setting('DEFAULT/rabbit_ha_queues').with_value() }
  it { should contain_setting('DEFAULT/admin_workers') }
  it { should contain_setting('DEFAULT/public_workers') }
  it { should contain_setting('DEFAULT/use_syslog').with_value(false) }
  it { should contain_setting('DEFAULT/log_dir').with_value('/var/log/keystone') }
  it { should contain_setting('paste_deploy/config_file').with_value('/usr/share/keystone/keystone-dist-paste.ini') }
  it { should contain_setting('token/driver').with_value('keystone.token.persistence.backends.sql.Token') }
  it { should contain_setting('token/expiration').with_value(3600) }
  it { should contain_setting('token/provider').with_value('keystone.token.providers.uuid.Provider') }
  it { should contain_setting('ssl/enable').with_value(false) }
  it { should contain_setting('database/connection').with_value('mysql://keystone:keystone@127.0.0.1/keystone') }
  it { should contain_setting('database/idle_timeout').with_value(200) }
  it { should contain_setting('catalog/driver').with_value('keystone.catalog.backends.sql.Catalog') }
  it { should contain_setting('catalog/template_file').with_value('/etc/keystone/default_catalog.templates') }
  it { should contain_setting('signing/certfile').with_value('/etc/keystone/ssl/certs/signing_cert.pem') }
  it { should contain_setting('signing/keyfile').with_value('/etc/keystone/ssl/private/signing_key.pem') }
  it { should contain_setting('signing/ca_certs').with_value('/etc/keystone/ssl/certs/ca.pem') }
  it { should contain_setting('signing/ca_key').with_value('/etc/keystone/ssl/private/cakey.pem') }
  it { should contain_setting('signing/cert_subject').with_value('/C=US/ST=Unset/L=Unset/O=Unset/CN=www.example.com') }
  it { should contain_setting('signing/key_size').with_value(2048) }
end
