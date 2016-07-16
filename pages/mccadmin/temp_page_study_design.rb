require_relative '../common/base_page'
require_relative 'sections'
require_relative 'page'

module Mccadmin

  # Elements and methods for temporary page
  class TempPageStudyDesign < Page
    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'
    section :search, Search, '#search-list-form'
    section :main, Main, '#main'

    elements :studies, '#studies > li > a'
    elements :mcc_sites, '#study-list > tbody > tr > td.protocol_id > span'
    elements :envs, '#study_environments > li > a'
    elements :sites, '#study_environment_sites > li > a'

    element :study_search_by_button, 'form#search-list-form div#search-by-attribute button[name="search_by_attribute"]'
    elements :study_search_by_attributes, 'form#search-list-form div#search-by-attribute ul > li'
    element :study_search_text, 'form#search-list-form input#search_by'
    element :study_search_button, 'form#search-list-form button#search-list-submit'

    set_url_matcher /.checkmate./

    #Navigates to specified study from the list of studies on temp page in MCC Admin
    # @param study_name [string] name of the study to click on
    def study_select(study_name)
      study = get_study(study_name) || study_search(study_name, 'Search by Name')
      raise "Study: #{study_name} is not available." unless study
      study.click
    end

    #Navigates to specified env from the list of envs on temp page in MCC Admin
    # @param env_name [string] name of the environment to click on
    def env_select(env_name)
      env = envs.detect { |item| item.text == env_name }
      if env
        env.click
      else
        raise "Environment: #{env_name} is not available."
      end
    end

    #Navigates to specified site from the list of sites on temp page in MCC Admin
    # @param site_name [string] name of the site to click on
    def site_select(site_name)
      # site = sites.detect {|item| item.text == site_name} || mcc_sites.detect {|item| item.text == site_name}
      site = mcc_sites.detect { |item| item.text == site_name }
      if site
        site.click
      else
        raise "Site: #{site_name} is not available."
      end
    end

    def study_search(study_name, by=nil)
      if by
        study_search_by_button.click
        study_search_by_attributes.detect { |attrib| attrib.text == by }.click
      end
      study_search_text.set study_name
      study_search_button.click
      get_study(study_name)
    end

    def get_study(study_name)
      studies.detect { |item| item.text == study_name } || mcc_sites.detect { |item| item.text == study_name }
    end
  end
end
