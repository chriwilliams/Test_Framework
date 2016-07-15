require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class Elearning < Common::BasePage

    set_url_matcher /.imedidata./

    section :header, Header, 'header#header'

    element :course_table, 'table#course_assignments_table'

    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def verify_page
      raise 'eLearning page not displayed correctly' unless self.has_course_table?
    end

  end
end