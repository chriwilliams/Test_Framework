
require 'logging'

module FirstFramework
  module Utils
    # Logging Mechanism based on Logging gem
    module Logger

      # @return [Logging::Logger]
      def log
        @log ||= Logger.logger_for(self.class.name)
      end

      attr_reader :loggers
      @loggers = {}

      class << self

        # for unit testing purposes only
        def loggers
          @loggers
        end

        # @param classname [Class] the class for which to log
        # @return [Logging::Logger]
        def logger_for(classname)
          @loggers[classname] ||= configure_logger_for(classname)
        end

        # @param classname [Class] the class for which to log
        # @return [Logging::Logger]
        def configure_logger_for(classname)
          raise LoggingConfigurationMissing, 'logging not found in configuration' unless  FirstFramework::Utils::Configuration['logging']
          raise LoggingFilePathMissing, 'logging filepath not found in configuration' unless  FirstFramework::Utils::Configuration['logging']['filepath']
          raise LoggingLevelMissing, 'logging level not found in configuration' unless  FirstFramework::Utils::Configuration['logging']['level']

          config =  FirstFramework::Utils::Configuration['logging']
          log = Logging.logger[classname]

          log.add_appenders(
              Logging.appenders.stdout('stdout', :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n')),
              Logging.appenders.file("#{config['filepath']}", :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n'))
          )

          # valid levels are debug, info, warn, error, fatal
          log.level = config['level'].to_sym
          log
        rescue LoggingConfigurationMissing, LoggingFilePathMissing, LoggingLevelMissing => e
          raise e
        rescue => e
          raise LoggingConfigurationError, "Inner Exception: #{e.to_s}"
        end

      end

      class LoggingConfigurationError < StandardError; end
      class LoggingConfigurationMissing < StandardError; end
      class LoggingFilePathMissing < StandardError; end
      class LoggingLevelMissing < StandardError; end

    end
  end
end
