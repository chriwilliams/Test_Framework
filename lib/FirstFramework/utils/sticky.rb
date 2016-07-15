module FirstFramework
  module Utils
    class Sticky < Hash

      def initialize(default_value=nil)
        super default_value
      end

      def [](key)
        raise FirstFramework::Utils::StickyKeyNotFound, "I don't have '#{key}' key" unless has_key? key
        super key
      end

      def set_value(key, value)
        self[key] = value
      end

      # @param data [String] reference to stored value
      # @return [Object] the stored value at reference
      # @raise [] when the reference is not found
      def get_value(data)
        result = data.dup
        result.scan(/(\w+|\w)\s*/).each { |memo| result.sub!("#{memo[0]}", self["#{memo[0]}"]) if self["#{memo[0]}"] } if result.is_a? String
        result
      end
    end

    class StickyKeyNotFound < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
  end
end

