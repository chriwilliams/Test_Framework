$:.unshift File.dirname(__FILE__)

module MediTAF
  def self.root
    File.expand_path '../..', __FILE__
  end
end

require 'MediTAF/version'
require 'MediTAF/services'
require 'MediTAF/ui'
require 'MediTAF/utils/meditaf_faker'
require 'MediTAF/utils/sticky'
require 'MediTAF/utils/mail'
