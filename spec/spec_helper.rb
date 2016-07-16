require 'simplecov'
SimpleCov.command_name 'RSpec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'rspec/expectations'
require 'require_all'

require_all 'lib'

