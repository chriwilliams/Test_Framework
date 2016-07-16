require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class CreateNewStudy < Common::BasePage

    section :header, Header, '#header'
    section :tab_navigation, TabNavigation, 'div[class="tabs"]'
    section :flash_notice, FlashNotice, '#flash-notice'

    element :study_name, '#study_name'
    element :study_oid, '#study_oid'
    element :submit_button, '#update_study_button'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Creates a new study with the following hash of params
    def create_new_study(params={})
      if params[:environment].downcase == 'prod'
        study_name.set params[:name]
        study_oid.set params[:protocol_id]
        is_production_study.click
        page.driver.browser.switch_to.alert.accept
      else
        study_name.set (params[:name] + " (#{params[:environment]})")
        study_oid.set params[:protocol_id]
      end
      submit_button.click
    end

  end

end
