require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'

module Mccadmin
  class CommonPage < Common::BasePage

    attr_reader :klass
    attr_accessor :description

    begin
      $async = MIST::AsyncHelper
      $mccadmin = MIST::SelectorHelper
      $mccadminFaker = MIST::FakerHelper
      SELECTOR_MAPPING = $mccadmin::SELECTOR_MAPPING['mccadmin']
      SELECTOR = $mccadmin::SELECTOR
      TEXTCONTENT = $mccadmin::TEXTCONTENT
      ELEMENT = $mccadmin::ELEMENT
      LABEL = $mccadmin::LABEL
      PANEL = $mccadmin::PANEL
      INPUT_FIELD = $mccadmin::INPUT_FIELD
      STATE = $mccadmin::STATE

      STUDY_DETAIL = 'Study Detail'
    end

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'
    section :search, Search, '#search-list-form'
    section :main, Main, '#main'

    element :file_upload, '#study_sites_upload_candidates_file'
    element :page_header, '.page-header-text'
    element :error_code, 'div[class=explanation_text] > h1'
    elements :trace_id, 'div[class=explanation_text] > div'

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(60)
      if page_header.text.include?('Error')
        notice = "Got an Error Page with Error: #{error_code.text} and Trace #{trace_id.last.text}"
        print_to_output(notice)
        raise notice
      end
    end

    # Click to attach a file using file upload
    # @param path [string] path to the file to be uploaded
    def bootstrap_attach_file(path)

      # Selenium likes absolute paths when attaching a file.
      path = File.expand_path(path)

      # selector will change depending on what page you are on, so we will check the page header text to determine this.
      # for Upload Sites the selector = "#study_sites_upload_candidates_file"
      # for Upload Users the selector = "#study_users_upload_candidates_file"
      page = $applications.mccadmin.manage_users.main.get_page_header

      if page.include?("Upload Sites")
        selector = "#study_sites_upload_candidates_file"
      elsif page.include?("Upload Users")
        selector = "#study_users_upload_candidates_file"
      else
        raise "cannot determine selector for current page"
      end

      # Do this to expose the file input field so it is clickable
      Capybara.current_session.driver.execute_script(
      "$('#{selector}').css('position','relative').css('opacity','1').height(10).width(10)")
      attach_file(selector[1..-1], path)
      Capybara.current_session.driver.execute_script("$('#upload-file').css('display','inline')")

    end
  end
end
