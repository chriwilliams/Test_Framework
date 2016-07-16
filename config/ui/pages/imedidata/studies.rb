require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class Studies < Common::BasePage

    set_url_matcher /.imedidata./

    section :header, Header, 'header#header'

    element :studies_table, '#studies_manage'

    element :study_groups, '#Study Groups'

    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def verify_page
      raise 'Studies page not displayed correctly' unless self.has_studies_table?
    end

  end

  class LogLines < Common::BasePage
    def initialize
      @lines = []
      0.upto(4) { |l| @lines << "log line #{l+1}" }
    end

    def size
      @lines.size
    end

    def read(line)
      @lines[line-1] if line > 0 && line < size
    end
  end
end