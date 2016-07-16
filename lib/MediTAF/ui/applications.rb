# Class Applications manages all configured applications in a single browser session

require_relative '../ui/application'

module MediTAF
  module UI
    # Manages all of the applications in the applications root directory
    class Applications
      include Enumerable

      attr_reader :apps_root
      attr_reader :apps
      attr_reader :current_app

      # @param apps_root [String] root location of applications with their defined pages
      def initialize(apps_root)
        @apps = {}
        @apps_root = apps_root
      end

      # only empties the applications internal apps collection
      def close
        @apps.clear
      end

      # references an application as a method name
      # @param app [Symbol] the application name as a symbol
      # @return [Application] the current application
      def method_missing(app, *args, &block)
        @current_app = @apps.include?(app) ? @apps[app] : load_app(app)
      end

      # iterates over the loaded applications collection
      # @param block [Proc]
      def each(&block)
        @apps.each(&block) if @apps
      end

      # @return [Symbol] the current application in use
      def current_app
        @current_app
      end

      private

      # @param app [Symbol] the application name as a symbol
      # @return [Application] the newly accessed application
      # @raise [AppLoadError] when manager cannot fully load the requested app
      def load_app(app)
        raise "Directory #{@apps_root}/#{app} not found" unless Dir["#{@apps_root}/*"].detect do |f|
          File.directory?(f) && File.basename(f).downcase.to_sym == app
        end
        new_app = Application.new("#{@apps_root}/#{app.to_s.downcase}")
        @apps[app] = new_app
      rescue => e
        raise AppLoadError, "Couldn't load #{app}. Inner Exception: #{e.to_s}"
      end
    end
  end
end