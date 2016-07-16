#require 'active_support/core_ext/string/inflections'

module MediTAF
  module UI
    # Manages all of the application's pages in the application's root directory
    class Application
      attr_reader :app_root
      attr_reader :pages
      attr_reader :current_page

      # @param app_root [String] path to the application's page models
      def initialize(app_root)
        @pages = {}
        @app_root = app_root
      end

      # references the page as a method name
      # @param page [Symbol] the page name as a symbol
      # @return [Object] the current page
      def method_missing(page, *args, &block)
        @current_page =
            if @pages.include?(page)
              @pages[page]
            elsif in_namespace?(page)
              new_page(@app_root + '/' + page.to_s)
            else
              load_page(page)
            end
      end

      # iterates over the loaded pages collection
      # @param block [Proc]
      def each(&block)
        @pages.each(&block) if @pages
      end

      # @return [Symbol] the current page in use
      def current_page
        @current_page
      end

      private

      # @param page [Symbol] the page name as a symbol
      # @return [MediTAF::UI:BasePage] the newly accessed page
      # @raise [PageLoadError] when manager cannot fully load the requested page
      def load_page(page)
        raise "File #{@app_root}/#{page.to_s}.rb not found" unless Dir["#{@app_root}/#{page.to_s}.rb"].detect do |f|
          !File.directory?(f) && File.basename(f, ".*").downcase.to_sym == page
        end
        class_path = @app_root + '/' + page.to_s
        require class_path
        new_page(class_path)
      rescue => e
        raise PageLoadError, "Couldn't load page #{page.to_s}. Inner Exception: #{e.to_s}"
      end

      def new_page(class_path)
        @pages[class_path.split('/').last.to_sym] = /^.+\/([^\/]+\/[^\/]+)$/.match(class_path)[1].camelize.constantize.new
      rescue => e
        raise PageLoadError, "Couldn't instantiate page #{page.to_s}. Inner Exception #{e.to_s}"
      end

      def in_namespace?(page)
        ns = /^.+\/[^\/]+\/([^\/]+)$/.match(@app_root)[1].camelize.constantize
        ns.constants.detect { |c| ns.const_get(c).is_a?(Class) && c == page.to_s.camelize.to_sym }
      rescue => e
        nil
      end
    end
  end
end
