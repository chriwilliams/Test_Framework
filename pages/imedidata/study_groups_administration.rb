require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class StudyGroupsAdministration < Common::BasePage

    section :header, Header, '#header'

    elements :study_groups, '.study_group_name > a'

    element :search_input, '#search_field_search_terms'
    element :search_button, '.input-group [type="submit"]'
    element :create_new_study_group, '#create_new_study_group'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Search for a particular study group
    # @param study_group [String] Name of the study group
    def search_for_study_group(study_group)
      search_input.set study_group
      search_button.click
    end

    # Select a particular study group
    # @param study_group_name [String] Name of the study group
    def select_study_group(study_group_name)
      study_group = study_groups.detect { |item| item.text.downcase.include? study_group_name.downcase }
      study_group.click
    end

    # Navigates to create new study group page
    def go_to_study_group_creation
      create_new_study_group.click
    end

  end

end
