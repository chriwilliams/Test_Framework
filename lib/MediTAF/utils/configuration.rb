require 'FirstFramework/utils/exceptions'

module FirstFramework
  # Representation of the FirstFramework_config.yml configuration file.
  module Utils
    module Configuration

      class << self
        # @param filepath [String] path/to/file
        # @raise [ConfigurationNotFoundError] when YAML cannot load the file
        def new(filepath = nil)
          filepath ||= Dir.glob(File.join("**", "FirstFramework_config.yml")).first
          yml_hashes = []

          # load main yaml file
          yml_hashes << YAML.load_file(filepath)
          raise FileEmpty, "#{filepath} is empty. Nothing to config, YAY!"  unless yml_hashes[0]

          # load additional yml files
          if yml_hashes[0]['modules']['config_files']
            yml_hashes[0]['modules']['config_files'].split(/ *, */).each { |f| yml_hashes << YAML.load_file(f) }
            modules = yml_hashes.shift
            added = yml_hashes.each_with_object({}) { |oh, nh| nh.merge!(oh) }
            modules['modules'].merge!(added)
          end
          modules ||= yml_hashes[0]

          # merge all yml hashes into one hash
          @modules = Settings.new('modules', modules['modules'] )
        rescue Errno::ENOENT => e
          raise FileNotFound, "missing configuration. check you have FirstFramework_config in the 'config' or " +
              "project root directory and is valid."
        rescue Psych::SyntaxError => e
          raise Error, "Configuration Error : #{e}"
        end

        # backward compatibility for older style references of Configuration['modules']['xxx']
        def [](key)
          (key == 'modules') ? @modules : @modules['modules'][key]
        end
      end

      class Settings
        def initialize(key, settings)
          @key = key
          @settings = settings
          self
        end

        def [](key)
          # backward compatibility for older style references of $config['modules']['xxx']
          return self if key == 'modules' && @key == 'modules'
          (@settings[key].is_a?(Hash)) ? Settings.new(@key + '/' + key, @settings[key]) : @settings[key] if @settings.has_key?(key)
        end

        def include?(key)
          @settings.has_key?(key)
        end

        private

        def []=(key, value)
          @settings[key] = value
        end

        def delete(key)
          @settings.delete(key) if @settings.has_key?(key)
        end
      end

      # When the specified configuration file has not configuration items i.e. EMPTY
      class FileEmpty < StandardError; end

      # Specified configuration file or FirstFramework_config.yml file not in config directory or project root directory
      class FileNotFound < StandardError; end

      # General configuration error: usually invalid YAML syntax
      class Error < StandardError; end

      # When request modules key is not found in configuration
      class ItemNotFound < StandardError; end
    end
  end
end
