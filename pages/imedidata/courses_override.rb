require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class CoursesOverride < Common::BasePage

    elements :all_courses, '#override_table > tbody > tr'
    element :save_button, '#course_overrides'

    section :header, Header, '#header'
    section :flash_notice, FlashNotice, '#flash-notice'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Toggle course override status
    # @param course_name [string] course name
    # @param set_override [boolean] Set or unset override
    # @param reason [string] Reason for override
    def toggle_course_override(course_name, set_override, reason_text=nil)
      course_row = all_courses.detect { |item| item.text.include? course_name }
      raise "course #{course_name} not found" unless course_row
      checkbox = course_row.all(:css, 'input[id$="_override"]').first
      if set_override
        raise 'reason is required to set override' unless reason_text
        checkbox.set true
        reason = course_row.all(:css, 'input[id$="_reason"]').first
        reason.set reason_text
      else
        checkbox.set false
      end
      save_button.click
      self.wait_until_save_button_invisible
    end

  end

end

