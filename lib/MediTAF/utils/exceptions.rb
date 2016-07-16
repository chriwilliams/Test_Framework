require 'MediTAF/utils/logger'

module MediTAF
  module Utils
    module Exceptions

      # MediTAF Exception with logging
      class MediTAFException < StandardError
        include MediTAF::Utils::Logger

        # @param message [String] error message.
        def initialize(message = 'MediTAF Exception') # Default Message
          log.error message
          super(message)
        end

      end

    end
  end
end
