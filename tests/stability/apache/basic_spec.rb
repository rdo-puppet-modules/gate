# Copyright (C) 2015 Red Hat, Inc.
#
# Author: Ben Kero <bkero@redhat.com>
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

# TODO: Add selinux labels

# Adds OPM CI path to LOAD_PATH
$:.unshift(File.dirname(File.dirname(__FILE__)))

require 'spec_helper'

pp = <<-EOS
class {'::apache': }
EOS

apply_manifest(pp, :catch_failures => true, :modulepath => "/usr/share/openstack-puppet/modules")
apply_manifest(pp, :catch_changes => true, :modulepath => "/usr/share/openstack-puppet/modules")

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running.under('apache') }
end

describe user('httpd') do
  it { should exist }
  it { should belong_to_group 'httpd' }
  it { should have_uid 48 }
  it { should have_home_directory '/usr/share/httpd' }
  it { have_login_shell '/sbin/nologin' }
end

describe group('httpd') do
  it { should exist }
  it { should have_gid 48 }
end

describe file('/etc/httpd') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf/httpd.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^ServerRoot "/etc/httpd"$' }
  its(:content) { should match '^PidFile run/httpd.pid$' }
  its(:content) { should match '^Timeout 120$' }
  its(:content) { should match '^KeepAlive Off$' }
  its(:content) { should match '^MaxKeepAliveRequests 100$' }
  its(:content) { should match '^KeepAliveTimeout 15$' }
  its(:content) { should match '^User apache$' }
  its(:content) { should match '^Group apache$' }
  its(:content) { should match '^AccessFileName \.htaccess$' }
  its(:content) { should match '^HostnameLookups Off$' }
  its(:content) { should match '^ErrorLog "/var/log/httpd/error_log"$' }
  its(:content) { should match '^LogLevel warn$' }
  its(:content) { should match '^EnableSendfile On$' }
  its(:content) { should match '^Include "/etc/httpd/conf.d/\*.load"$' }
  its(:content) { should match '^Include "/etc/httpd/conf/ports.conf"$' }
  its(:content) { should match '^LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined$' }
  its(:content) { should match '^LogFormat "%h %l %u %t \"%r\" %>s %b" common$' }
  its(:content) { should match '^LogFormat "%{Referer}i -> %U" referer$' }
  its(:content) { should match '^LogFormat "%{User-agent}i" agent$' }
  its(:content) { should match '^IncludeOptional "/etc/httpd/conf.d/\*.conf"$' }
end

describe file('/etc/httpd/conf/magic') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:md5sum) { should eq '4ae7974b3fcff79dec1464d17f26770d' } # File is not changed often
end

describe file('/etc/httpd/conf/ports.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^Listen 80$' }
end

describe file('/etc/httpd/conf.d') do
  it { should be_diretory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/conf.d/15-default.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:md5sum) { should eq 'a430bf4e003be964b419e7aea251c6c4' }

describe file('/etc/httpd/conf.modules.d') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/httpd/logs') do
  it { should be_linked_to '/var/log/httpd' }
end

describe file('/etc/httpd/modules') do
  it { should be_linked_to '/usr/lib64/httpd/modules' }
end

describe file('/etc/httpd/run') do
  it { should be_linked_to '/run/httpd' }
end

describe file('/var/log/httpd') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/lib64/httpd/modules') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

# TODO: Test each module (md5sums perhaps?)

describe file('/run/httpd') do
  it { should be_directory }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
