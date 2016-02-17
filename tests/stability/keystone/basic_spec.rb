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

describe file('/etc/keystone/keystone.conf') do
  its(:content) { should match '^admin_token = my_special_token' }
  its(:content) { should match '^#public_bind_host = 0.0.0.0' }
  its(:content) { should match '^#admin_bind_host = 0.0.0.0' }
  its(:content) { should match '^#public_port = 5000' }
  its(:content) { should match '^#admin_port = 35357' }
  #its(:content) { should match 'verbose = True' }
  #its(:content) { should match 'debug = True' }
  #its(:content) { should match 'rabbit_password =  }
  #its(:content) { should match 'rabbit_userid =  }
  #its(:content) { should match 'rabbit_virtual_host = /' }
  #its(:content) { should match 'rabbit_host =  }
  #its(:content) { should match 'rabbit_port =  }
  #its(:content) { should match 'rabbit_hosts =  }
  #its(:content) { should match 'rabbit_ha_queues =  }
  its(:content) { should match '^admin_workers' }
  its(:content) { should match '^public_workers' }
  its(:content) { should match '^#use_syslog = false' }
  its(:content) { should match '^log_dir = /var/log/keystone' }
  its(:content) { should match '^config_file = /usr/share/keystone/keystone-dist-paste.ini' }
  its(:content) { should match '^driver = keystone.token.persistence.backends.sql.Token' }
  its(:content) { should match '^expiration = 3600' }
  its(:content) { should match '^provider = keystone.token.providers.uuid.Provider' }
  its(:content) { should match '^#enable = false' }
  its(:content) { should match(/^connection = sqlite:\/\/\/\/var\/lib\/keystone\/keystone.sqlite$/) }
  its(:content) { should match '^#idle_timeout = 0' }
  its(:content) { should match '^driver = keystone.catalog.backends.sql.Catalog' }
  its(:content) { should match '^template_file = /etc/keystone/default_catalog.templates' }
  its(:content) { should match '^certfile = /etc/keystone/ssl/certs/signing_cert.pem' }
  its(:content) { should match '^keyfile = /etc/keystone/ssl/private/signing_key.pem' }
  its(:content) { should match '^ca_certs = /etc/keystone/ssl/certs/ca.pem' }
  its(:content) { should match '^ca_key = /etc/keystone/ssl/private/cakey.pem' }
  its(:content) { should match '^cert_subject = /C=US/ST=Unset/L=Unset/O=Unset/CN=www.example.com' }
  its(:content) { should match '^key_size = 2048' }
end
