$:.unshift File.dirname(__FILE__)

module FirstFramework
  def self.root
    File.expand_path '../..', __FILE__
  end
end

require 'FirstFramework/version'
require 'FirstFramework/services'
require 'FirstFramework/ui'
require 'FirstFramework/utils/FirstFramework_faker'
require 'FirstFramework/utils/sticky'
require 'FirstFramework/utils/mail'
