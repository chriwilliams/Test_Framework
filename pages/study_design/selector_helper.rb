module MIST
  module Janus
    class SelectorHelper
      attr_accessor :locale
      begin
        @@locale = 'eng'
        dir = File.expand_path(File.dirname(__FILE__))
        SELECTOR_MAPPING={}
        LOCALES_MAPPING ={}
        Dir[File.join(dir, 'locators', '*.yml')].each { |file| SELECTOR_MAPPING.merge!(YAML.load(File.open(file))) }
        Dir[File.join(dir, 'locales', '*.yml')].each { |file| LOCALES_MAPPING.merge!(YAML.load(File.open(file))) }
      end

      def self.locale(value=nil)
        @@locale = value if value
        @locale = @@locale
      end

      ## Common Constants
      READ_ONLY = 'read only'
      SELECTOR = 'selector'
      TEXTCONTENT = 'text'
      ELEMENT = 'element'
      LABEL = 'label'
      PANEL = 'panel'
      INPUT_FIELD = 'input-field'
      STATE = 'state'

      MAX_WAIT = ENV["DEFAULT_WAIT_TIME"]||30
      MAX_WAIT_ON_LOAD = 20
      WAY_TOO_LONG_TO_LOAD = 30
      PULSE = 0.1
    end
  end
end
