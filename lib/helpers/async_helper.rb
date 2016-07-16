require 'capybara'
require 'with_retries'

module MIST
  class AsyncHelper
    class << self
      def wait_until(wait_time = Capybara.default_wait_time)
        require "timeout"
        Timeout.timeout(wait_time) do
          sleep(0.1) until yield == true
        end
      end

      # @param params [Hash] optional parameters
      # @option params [Array|StandardError] :errors an StandardError object or an Array of StandardError objects
      # @option params [Integer] :attempts number to retries to attempt
      # @option params [Number] :timeout second to sleep between attempts
      def wait_with_retries(params={})
        attempts = params[:attempts] ? params[:attempts] : 9
        with_retries([*params[:errors], Capybara::ElementNotFound, SitePrism::TimeOutWaitingForElementVisibility], {timeout: params[:timeout], attempts: attempts}) do
          yield
        end
      end
    end
  end
end
