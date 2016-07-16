require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class OtherSettings < Common::BasePage

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def coder_configuration_select
      coder_config_link = self.find_link("Coder Configuration")
      coder_config_link.click
    end

    def user_groups_select
      user_groups_link = self.find_link("User Groups")
      user_groups_link.click
    end

  end
end