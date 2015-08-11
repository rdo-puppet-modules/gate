
require 'serverspec'
require 'yaml'

require 'addons/type/config'
require 'addons/matcher/contain_setting'

set :backend, :exec

if File.file?('/var/lib/hiera/defaults.yaml')
  set_property YAML.load_file('/var/lib/hiera/defaults.yaml')
end
