require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Studies < Common::BasePage

    section :main_nav, MainNav, '#mainnav'

    # search elements
    element :name, '#name_substr' #text field
    element :study_group, '#medidata_study_group_id' #dropdown
    element :live, '#live' #dropdown
    element :apply, '#apply_button' #button
    element :reset, '#reset_button' #button

    # table elements
    elements :studies, '#study_list td.name a' #collection links
    elements :subject, '#study_list td.subject_count a' #collection links
    elements :sites, '#study_list td.site_count a' #collection links
    elements :configs, '#study_list td.configuration_report a' #collection links


    # Clicks on the given study in the studies table
    # @param study_name [string] study name
    def select_study(study_name)
      index = get_element_index(studies, study_name)
      studies[index].click
    end

    # Clicks on the subject count for the given study in the studies table
    # @param study_name [string] study name
    def select_subject_count(study_name)
      index = get_element_index(studies, study_name)
      subject[index].click
    end

    # Clicks on the sites link for the given study in the studies table
    # @param study_name [string] study name
    def select_site_link(study_name)
      index = get_element_index(studies, study_name)
      sites[index].click
    end

    # Clicks on the config report for given study in the studies table
    # @param study_name [string] study name
    def select_config_report(study_name)
      index = get_element_index(studies, study_name)
      configs[index].click
    end

    #Performs a search based on search fields passed
    # @param study_name [string] study name
    # @param study_group_option [string] study group name
    # @param live_option [string] live or not live option
    def search_for_study(study_name=nil,study_group_option=nil,live_option=nil)
      reset.click
      name.set study_name if study_name != nil
      stugy_group.select study_group_option if study_group_option != nil
      live.select live_option if live_option != nil
      apply.click
    end

  end
end