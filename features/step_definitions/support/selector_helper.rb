module MIST
  class SelectorHelper
    def self.merge_yamls(dir)
      Dir[File.join(dir, '*.yml')].inject({}) { |ymls, yml| ymls.merge! YAML.load(File.open(yml)) }
    end

    SELECTOR_MAPPING = Dir['./pages/*'].inject({}) do |c, dir|
      locators = File.join(dir, '/', 'locators')
      c.merge!(dir[/\/([^\/]+)$/, 1] => merge_yamls(locators)) if Dir.exist?(locators)
      c
    end

    ## Common Constants
    SELECTOR = 'selector'
    TEXTCONTENT = 'text'
    ELEMENT = 'element'
    LABEL = 'label'
    PANEL = 'panel'
    INPUT_FIELD='input-field'
    STATE = 'state'

    MAX_WAIT=ENV["DEFAULT_WAIT_TIME"]||40
    MAX_WAIT_ON_LOAD = 60
    WAY_TOO_LONG_TO_LOAD = 300
    PULSE = 0.1

  end
end
