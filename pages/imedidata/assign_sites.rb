require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class AssignSites < Common::BasePage

    section :header, Header, '#header'
    section :flash_notice, FlashNotice, '#flash-notice'

    elements :site_rows, 'tbody[id=study_site_assignment_rows] > tr:nth-child(2) > td'
    element :search_input, '#search_field_search_terms'
    element :search_button, '.input-group [type="submit"]'
    element :save_button, '#submit_button'
    element :reset_button, '#reset_button'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def search_site(site)
      search_input.set(site)
      search_button.click
      sleep 5 #Wait for search results
    end

    def assign_site(params={})
      if site_rows.last.text.include? params['Site Name']
        access = case params['Access'].downcase
                  when 'none'
                    site_rows[0]
                  when 'user'
                    site_rows[1].find('label')
                  when 'owner'
                    site_rows[2].find('label')
                  else
                    nil
                end
        raise "No option found for access as '#{params['Access']}'" if access.nil?
        access.click if access.visible?
      else
        raise "Site name as #{params['Site Name']} does not exist!"
      end
      save_button.click
    end

  end
end