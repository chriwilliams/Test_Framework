require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class Studies < Common::BasePage

    section :header, Header, '#header'

    element :studies_table, '#studies_manage'

    element :study_groups, '#Study Groups'
    element :create_study_link, '#create_new_study'
    element :enter_study_name, '#study_name'
    element :enter_study_oid, '#study_oid'
    element :is_production_study, 'input[id$="study_is_production"]'
    element :save_study, '#update_study_button_active_submit'
    element :sites, '#sites'
    element :users, '#users'


    set_url_matcher /.imedidata./

    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Creates a study within a SG
    # @param study_name [String] name of the study you would like to give it. It will be randomized
    # @param study_protocol [String] protocol number for the study. It will be randomized.
    # @param is_production [String] what type of study it is
    def create_study(study_name, study_protocol, study_type)
      create_study_link.click
      enter_study_name.set study_name
      enter_study_oid.set study_protocol
      if study_type.downcase == 'prod'
        is_production_study.click
        page.driver.browser.switch_to.alert.accept
        $sticky[:prod_study_value] = study_name
      else
        $sticky[:regular_study_value] = study_name
      end
      save_study.click
    end

    def tab_navigation(tab)
      case tab
        when 'Sites'
          sites.click
        when 'Users'
          users.click
        else
          raise "Error selecting tab #{tab}. Either unknown tab selection provided or there is no code coverage for selecting your tab."
      end
    end

  end
end
