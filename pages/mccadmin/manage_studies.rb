require_relative '../common/base_page'
require_relative 'sections'

module Mccadmin

  # Elements and methods for 'All Studies' page
  class ManageStudies < Common::BasePage

    section :main_nav, LeftNav, '#sidebar'
    section :env_filter, EnvironmentPanel, '#content-panel'

    elements :study_protocol, "#study-list td:nth-child(1)"
    elements :study_name, "#study-list td:nth-child(2)"


    # Selecs a study from the list of studies
    # @param name [string] name of the study
    def select_study(name)
      index = get_element_index(study_name, name)
      study_name[index].click
    end

  end
end