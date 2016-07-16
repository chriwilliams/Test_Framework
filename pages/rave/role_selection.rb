require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class RoleSelection < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'

    element :role_selection, 'select#_ctl0_Content_RolesDDL'
    element :continue, 'input#_ctl0_Content_ContinueButton'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def select_role(role)
      select(role, :from => role_selection[:id])
      continue.click
    end

  end
end