require_relative '../common/base_page'
require_relative 'sections'

module Rave

  class Architect < Common::BasePage

    element :active_project_table, 'table[id$="_ProjectGrid"]'
    element :architect_menu_table, 'table#TblOuter'

    set_url_matcher /\/MedidataRave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Selects Project from Active Projects in Architect
    # @param project [string] Project Name
    def active_project_select(project)
      project_link = active_project_table.find('a', :text => /\A#{project}\z/)
      project_link.native.send_keys(:enter)
    end

    # Navigates through Architect menu.
    # @param link [string] Menu item Name
    def architect_menu_nav(link)
      menu_item = architect_menu_table.all(:css, 'a', :text => "#{link}").first
      menu_item.click
    end

  end
end