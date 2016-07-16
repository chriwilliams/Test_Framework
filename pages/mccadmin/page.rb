require_relative 'common_page'

module Mccadmin

  # Elements and methods for temporary page
  class Page < Mccadmin::CommonPage

    elements :studies, '#studies > li > a'
    elements :envs, '#study_environments > li > a'
    elements :sites, '#study_environment_sites > li > a'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    #Navigates to specified study from the list of studies on temp page in MCC Admin
    # @param study_name [string] name of the study to click on
    def study_select(study_name)
      study = studies.detect { |item| item.text == study_name }
      if study
        study.click
      else
        raise "Study: #{study_name} is not available."
      end
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
      site = sites.detect { |item| item.text == site_name }
      if site
        site.click
      else
        raise "Site: #{site_name} is not available."
      end
    end
  end
end
