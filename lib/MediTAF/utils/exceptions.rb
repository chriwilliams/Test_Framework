require 'FirstFramework/utils/logger'

module FirstFramework
  module Utils
    module Exceptions

      # FirstFramework Exception with logging
      class FirstFrameworkException < StandardError
        include FirstFramework::Utils::Logger

        # @param message [String] error message.
        def initialize(message = 'FirstFramework Exception') # Default Message
          log.error message
          super(message)
        end

      end

    end
  end
end
