require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class CreateNewStudyGroup < Common::BasePage

    section :header, Header, '#header'
    section :flash_notice, FlashNotice, '#flash-notice'

    elements :all_apps, '#apps_access > div'
    elements :all_courses, '#course_access > div'

    element :sg_name, '#study_group_name'
    element :sg_oid, '#study_group_oid'
    element :is_mccadmin_only, '#study_group_mcc_enabled_true'
    element :save_button, '#new_study_group_button'
    element :cancel_button, 'a[href*=study_groups]'
    element :sg_title, 'div[class=manage_title]'

    element :test_app, '#app_10260'
    element :test_course, '#Test_Sample_Course'
    element :test_app_sb, '#app_235'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Creates a new study with the following hash of params
    # @param [Hash] params the options to create a course with.
    # @option params [String] 'name' Study Group Name
    # @option params [String] 'oid' Study Group OID
    # @option params [Boolean] 'is_mccadmin_only'
    # @option params [Array<String>] 'apps' Apps
    # @option params [Array<String>] 'courses' Courses
    def create_study_group(params={})
      sg_name.set params['name']
      sg_oid.set params['oid']
      is_mccadmin_only.set(true) if params['is_mccadmin_only'].downcase.include?('true')

      # check if apps are specified
      if params['apps']
        # special case for Test App
        if params['apps'].include?("Test App-MCC")
          select_test_app
        else
          select_apps(params['apps'])
        end
      end

      # check if courses are specified
      if params['courses']
        if params['courses'].include?("Test Sample Course")
          test_course.set(true)
        else
          select_courses(params['courses'])
        end
      end
      save_button.click
      sleep 10 #Wait for role assignments
    end

    # Selects id of Test App
    def select_test_app
      # get environment
      env = $config['modules']['ui']['apps']['imedidata']['base_url']

      if env.include? "sandbox"
        test_app_sb.find('input').set(true)
      elsif env.include? "validation"
        test_app.find('input').set(true)
      end
    end

    # Returns the title of the study group which includes the name and corresponding client_division_uuid
    # @return [Hash<String>] :name Study Group Name, :uuid Client Division UUID
    def get_study_group_title
      temp = sg_title.text.delete('()').gsub('client_division_uuid','').gsub('uuid','').split(':').map(&:strip)
      name_and_uuid = {}
      name_and_uuid[:name] = temp.first
      name_and_uuid[:uuid] = temp.last
      name_and_uuid
    end

    private

    def select_apps(apps)
      select_it(all_apps, apps)
    end

    def select_courses(courses)
      select_it(all_courses, courses)
    end

    def select_it(collection, items)
      items.each do |item|
        an_item = collection.detect { |colitem| colitem.text.downcase.include? item.strip.downcase }
        raise "No such option as #{item} is found!" if an_item.nil?
        an_item.find('input').set(true)
      end
    end

  end

end
