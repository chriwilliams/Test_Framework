# Module ui namespace for all ui related capabilities
require 'MediTAF/utils/exceptions'

module MediTAF
  # Enables MediTAF to interact with the UI via the page object model design pattern. It manages applications and their
  # associated pages (i.e. page objects).
  module UI
    # @param pages_root [String] specifies location of applications' pages. default location: pages
    def self.new(pages_root='pages')
      Applications.new('./' + Dir.glob(File.join("**", pages_root)).first)
    end

    # Applications manager was unable to find a directory with the name of the application
    class AppLoadError < MediTAF::Utils::Exceptions::MediTAFException; end

    # Pages Manager (i.e. the Application) was unable to find a file presentation the page model
    class PageLoadError < MediTAF::Utils::Exceptions::MediTAFException; end

    # BaseURL for launching the application is missing.
    class BaseURLMissing < MediTAF::Utils::Exceptions::MediTAFException; end

  end
end

require_relative 'ui/applications'