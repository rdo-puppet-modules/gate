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
require 'inifile'

module Serverspec
  module Type

    class Config < Base
      attr_accessor :path

      def initialize(path)
        @path = path
      end

      def content
        if not @content
          begin
            @content = ::IniFile.load(@path)
          rescue IniFile::Error
            # fallback for files which might contain
            # values out of INI file specification
            raw = ''
            ::File.open(@path).each do |line|
              # Cinder's api-paste.ini
              if /^\s*\/\w*:/.match(line)
                next
              end
              raw += line
            end
            @content = ::IniFile.new( :content => raw )
          end
        end
        @content
      end

      def to_s
        "Config \"#{@path}\""
      end

      def contain_setting?(setting, value)
        section, variable = setting.split('/')
        if content.has_section? section
          if content[section].has_key? variable
            if value == nil or content[section][variable] == value
              return true
            end
          end
        end
        false
      end
    end

    def config(path)
      Config.new(path)
    end

  end
end

include Serverspec::Type
