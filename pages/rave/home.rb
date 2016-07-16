require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Home < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'
    section :navigation_tabs, NavigationTabs, 'table[id$="PgHeader_TabTable"]'
    section :main_subject_menu_nav, SubjectMenuNav, 'table[id$="LeftNav_ModuleList_DisplayBox_DisplayGrid"]'

    elements :study_links, 'a[id$=hpObject]'
    element :study_search_text, 'input[id$="ListDisplayNavigation_txtSearch"]'
    element :study_search_button, 'input[id$="ListDisplayNavigation_ibSearch"]'
    element :useradmin_link, :xpath, "//a[contains(text(),'User Administration')]"
    element :first_site_name, '#_ctl0_Content_ListDisplayNavigation_dgObjects tr:nth-of-type(2) td:nth-of-type(2)'
    element :study_name, '#_ctl0_PgHeader_TabTextHyperlink1'


    set_url_matcher /\/medidatarave\//i

    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # searches for study with specified name
    #@param study_name [String] name of the study
    def study_search(study_name)
      study = (study_name.sub(/\(.+\)/, "")).strip
      study_tab = navigation_tabs.all_tabs.detect { |inner_item| inner_item.text == study_name }

      unless study_tab
        study_search_text.set study
        study_search_button.click
        study_link = study_links.detect { |inner_item| inner_item.text == study_name }
        study_link.click if study_link
      end
    end

    # this functions selects user admin link from the navigation menu on rave home page.
    def useradmin_select
      useradmin_link.click
    end

    # selects configuration link from the navigation menu on rave home page.
    def configuration_select
      main_menu_select('Configuration')
    end

    # selects architect link from the navigation menu on rave home page.
    def architect_select
      wait_for_navigation_tabs
      main_menu_select('Architect')
    end

    # selects "Home" tab.
    def home_tab_select
      main_menu_select('Home')
    end

    # selects main menu link from the navigation menu on rave home page.
    def main_menu_select(name)
      sleep 1
      menu_link = self.find_link(name)
      menu_link.click
    end

    def select_first_rave_study_site
      click_link(get_first_site_name)
    end

    def get_study_name
      study_name.text
    end

    def get_first_site_name
      first_site_name.text
    end
  end
end