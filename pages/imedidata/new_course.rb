require_relative '../common/base_page'

module Imedidata

  class NewCourse < Common::BasePage

    element :course_name, '#course_name'
    element :course_oid, '#course_oid'
    element :description, '#course_description'
    element :passing_score, '#course_passing_score'
    element :prerequisite,  '#course_prerequisite_id'
    element :course_locale, 'select[id$="_locale"]'
    element :course_duration, 'input[id$="_duration"]'
    element :submit_button, '#active_submit'
    element :course_file, 'input[id$=_file_attachment_attributes_attachment]'

    set_url_matcher /.courses./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Creates a new course with the following hash of params
    # @param [Hash] param the options to create a course with.
    # @option param [String] 'name' Course Name
    # @option param [String] 'oid' Course OID
    # @option param [String] 'description' Description
    # @option param [String] 'passing_score' Passing Score %
    # @option param [String] 'prereq' Prerequisite
    # @option param [String] 'locale' Locale
    # @option param [String] 'duration' Duration (Mins)
    # @option param [File] 'course_file' Course File
    def create_course(param = {})
      course_name.set param['name']
      course_oid.set param['oid']
      description.set param['description']
      passing_score.set param['passing_score']
      prerequisite.select(param['prereq']) unless create_course_params['prereq'] == 'N/A'
      course_locale.select(param['locale'])
      course_duration.set param['duration']
      upload_file('Course File', param['course_file'])
      submit_button.click
    end
  end
end

