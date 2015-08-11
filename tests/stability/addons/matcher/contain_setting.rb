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
require 'rspec'

RSpec::Matchers.define :contain_setting do |setting|
  match do |subject|
    subject.contain_setting?(setting, @value)
  end

  chain :with_value do |value|
    @value = value
  end

  description do
    msg = "contain setting '#{setting}'"
    if @value != nil
      msg += " with value '#{@value}'."
    end
    msg   
  end
end
