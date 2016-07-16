require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class Admin < Common::BasePage

    section :header, Header, '#header'

    element :study_groups, 'a[href*="study_groups"]'
    element :teams, 'a[href*="teams"]'
    element :apps, 'a[href*="apps"]'
    element :app_types, 'a[href*="app_types"]'
    element :courses, 'a[href*="courses"]'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Loads the corresponding page depending on the item link
    # @param item [Symbol]
    def load_admin_page_for(item)

      case item
         when :study_groups;
           study_groups.click
         when :teams;
           teams.click
         when :apps;
           apps.click
         when :app_types;
           app_types.click
         when :courses;
           courses.click
         else
           raise 'Invalid input for load_admin_page_for'
      end
    end

  end



end

