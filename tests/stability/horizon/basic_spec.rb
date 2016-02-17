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

describe file('/etc/httpd/conf') do
  it { should be_directory }
end

describe file('/etc/httpd/conf.d') do
  it { should be_directory }
end

describe file('/var/www/html') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/var/log/httpd') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf/ports.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf/httpd.conf') do
  it { should be_file }
end

for i in [
  'env', 'logio', 'substitute', 'usertrack', 'authn_core', 'auth_basic',
  'log_config', 'systemd', 'unixd', 'authz_host', 'authz_core', 'auth_digest',
  'authn_anon', 'authn_dbm', 'authz_dbm', 'access_compat', 'authz_owner',
  'expires', 'ext_filter', 'include', 'authz_groupfile', 'actions', 'cache',
  'mime', 'mime_magic', 'rewrite', 'speling', 'suexec', 'version', 'cgi',
  'vhost_alias', 'alias', 'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir',
  'deflate', 'negotiation', 'setenvif', 'filter', 'authz_user', 'wsgi'
] do
  describe file("/etc/httpd/conf.d/#{i}.load") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

for i in [
  'mime.conf', 'mime_magic.conf', 'alias.conf', 'autoindex.conf',
  'dav_fs.conf', 'deflate.conf', 'dir.conf', 'negotiation.conf',
  'setenvif.conf', 'wsgi.conf', '15-default.conf'
] do
  describe file("/etc/httpd/conf.d/#{i}") do
    it { should be_file }
  end
end

describe file('/etc/openstack-dashboard/local_settings') do
  it { should be_file }
  it { should be_mode 644 }
end

describe file('/var/log/horizon') do
  it { should be_directory }
  it { should be_mode 751 }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
end

describe file('/var/log/horizon/horizon.log') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
end

describe file('/etc/httpd/conf.d/15-horizon_vhost.conf') do
  it { should be_file }
end
