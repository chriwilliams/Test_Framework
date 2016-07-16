require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'

module Imedidata

  class CourseMappingLightbox <  Common::BaseSection
    element :app_selector, 'select[id$=app_id]'
    element :role_selector, 'select[id$=role_id]'
    element :add_app_button, 'a[id=add_app_button]'
    element :submit_button, '.buttons [type="submit"]'
    element :cancel_button, '.buttons [title="lbAction negative button"]'

    # Add app-role mapping for the course
    # @param app [string] App Name
    # @param role [string] Role Name
    def add_mapping(app, role)
      app_selector.select(app)
      self.wait_until_role_selector_visible
      role_selector.select(role) unless app.downcase == 'all'
      submit_button.click
    end

  end

  class ManageStudyGroup < Common::BasePage

    section :notifications, Notifications, '#notifications'
    section :header, Header, '#header'
    section :sg_tab_navigation, TabNavigation, '#study_groups_manage'
    section :study_tab_navigation, TabNavigation, '#studies_manage'
    section :course_mapping_lightbox, CourseMappingLightbox, '#lightbox'
    section :flash_notice, FlashNotice, '#flash-notice'

    element :create_site, '#create_sites'
    element :create_study, '#create_new_study'

    elements :courses, 'tr[id^="course_"]'
    element :all_studies, '#studies_in_study_group_list'
    element :searchfield, '#search_field_search_terms'
    element :searchbutton, '.go_button'
    elements :userstable, 'table[class="users_table"] > tbody > tr[id^=invited_user] > td'
    elements :assign_site, 'a[id$=_assign_sites]'
    attr_reader :userfield

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Add app-role mapping for the course
    # @param [Hash] params includes parameters required for mapping course
    # @option params [String] :course Course Name
    # @option params [String] :app App Name
    # @option params [String] :role Role
    def add_mapping(params = {})
      course_element = courses.detect {|inner_item| inner_item.text.downcase.include? params[:course].downcase}
      course_element.find_link('Add').click
      self.wait_until_course_mapping_lightbox_visible
      course_mapping_lightbox.add_mapping(params[:app], params[:role])
      self.wait_until_course_mapping_lightbox_invisible
    end

    def select_sg_tab(tab)
      sg_tab_navigation.click_tab(tab)
    end

    def select_study_tab(tab)
      study_tab_navigation.click_tab(tab)
    end

    # clicks create new site site button
    def create_new_site
      create_site.click
    end

    # clicks create new study button
    def create_new_study
      create_study.click
    end

    def search_for_the_user(username)
      10.times do
        searchfield.set username
        searchbutton.click
        sleep 2
        link= assign_site.first
        break unless link.nil?
      end
    end

    def select_elearning(username)
      searchfield.set username
      searchbutton.click
    end

    # detects field label on imedidata page
    # @param label [string] the field name
    def user_table_field_detect(label)
      @userfield = userstable.detect { |item| item.text.include? label }

      raise "Field '#{label}' was not found on form." unless @userfield
    end

    # Clicks on specified actions for the specified data field.
    # @param label [string] is label of the data field to perform action.
    # @param action [string] is action to perform.
    def users_field_select(value)
     user_table_field_detect(value)
     action_item = @userfield.all(:css, '[id$="_elearning"]').first[:id]
      if action_item
        action_item.click
      else
        raise "Action: #{value} is not available for the field."
      end
    end

    # clicks on the study name to go to manage study page
    # @param study_name [string] Name of the study to select
    def select_study(study_name)
      item = all_studies.find_link(study_name)
      if item
        item.click
      else
        raise "Study #{study_name} was not found"
      end

    end

  end
end

