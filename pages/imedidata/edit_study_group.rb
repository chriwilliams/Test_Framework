require_relative 'sections'
require_relative '../imedidata/create_new_study_group'


module Imedidata

  class EditStudyGroup < Imedidata::CreateNewStudyGroup

    element :save, '.buttons [type="submit"]'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      super
    end

    # Creates a new study with the following hash of params
    # @param [Hash] params the options to create a course with.
    # @option params [Array<String>] 'apps' Apps
    # @option params [Array<String>] 'courses' Courses
    def add_apps_and_courses(params={})
      unless params['Apps'].empty?
        if params['Apps'].include?("Test App-MCC")
          test_app.find('input').set(true)
        else
          select_apps(params['Apps'])
        end
      end

      unless params['Courses'].empty?
        if params['courses'].include?("Test Sample Course")
          test_course.set(true)
        else
          select_courses(params['Courses'])
        end
      end
      save.click
    end

  end

end
