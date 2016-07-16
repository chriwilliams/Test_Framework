require_relative '../common/base_page'

module Imedidata

  class Courses < Common::BasePage

    section :header, Header, '#header'

    elements :courses, '#pane_data > div > table > tr.courses_header > td.course_name > a'

    element :search_input, '#search_field_search_terms'
    element :search_button, '#admin_course_search > div.search_button > a'
    element :create_new_course, '#create_new_course'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Search for a specific course
    # @param course [String]
    def search_for_course(course)
      search_input.set course
      search_button.click
    end

    # Select a specific course from the list of courses
    # @param course_name [String]
    def select_course(course_name)
      course = courses.detect { |item| item.text.downcase.include? course_name.downcase }
      course.click
    end

    # Navigate to the new course page
    def go_to_course_creation
      create_new_course.click
    end

  end

end

