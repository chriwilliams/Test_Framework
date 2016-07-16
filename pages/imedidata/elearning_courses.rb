require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class ElearningCourses < Common::BasePage

    set_url_matcher /.imedidata./

    section :header, Header, '#header'

    elements :course_table, 'table[id=course_assignments_table] > tbody > tr[id^=course]'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def verify_course_status(course)
      status = ""
      course_table.each do |courses|
        if courses.text.include?(course)
          columns = courses.all('td').take(2)
          status = columns.last.text
          break
        end
      end
      status
    end

  end
end