require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Site < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'

    element :search_text, 'input[id$="txtSearch"]'
    element :search_image, 'input[id$="ibSearch"]'
    element :add_subject_image, 'input[id$="ibAddSubject"][type="image"]'
    element :labs_link, 'a[id*="LabsImgLink"]'
    element :advance_search_link, 'a[id*="lbAdvancedSearch"]'
    element :subject_table, 'table[id$="Content_ListDisplayNavigation_dgObjects"]'
    element :site_tabs, 'table[id$="PgHeader_TabTable"]'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    #Adds new subject
    def subject_add
      add_subject_image.click
    end

    # Searches for the specified subject
    # @param subject [string] subject name
    def subject_search(subject)
      search_text.set subject
      search_image.click
    end

    # selects the subject from the subject table
    # @param subject [string] the subject name you want to click on
    def subject_select(subject)
      subject = subject_table.all(:css, 'a', :text => "#{subject}").first

      raise "Subject #{subject} not found" unless subject

      subject.click
    end

    # retrieves the value of the current Study Site
    def site_name_get
      site_tabs.all(:css, 'a').last
    end
  end
end
