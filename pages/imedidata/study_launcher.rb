require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class StudyLauncher < Common::BasePage

    set_url_matcher /.imedidata./

    section :header, Header, '#header'
    element :app, '#apps'

    elements :app_type, '#apps div.app_box div.[id^="app_type_"]'
    elements :app_name, '#apps div.app_box div.app_name'
    elements :app_name_value, '#apps div.app_box div.app_name span.name'
    elements :app_name_category, '#apps div.app_box div.app_name span.category'


    # element :study_launcher, '#apps div.app_box div.study_group_launcher'
    elements :study_launcher_items, '#apps div.app_box div.study_group_launcher a'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # finds a study, study group, site, or team
    # @param what [Hash] what to find and its name
    def get_item(what)
      key = what.keys[0]
      case key
        when :study_group
          item = study_launcher_items.detect { |inner_item| inner_item.text == what[key] }
        when :app
          item = app_name.detect { |inner_item| inner_item.text == what[key] }
        when :app_type
          item = app_type.detect { |inner_item| inner_item.text == what[key] }
        when :app_name, :app_name_value
          item = app_name_value.detect { |inner_item| inner_item.text == what[key] }
        when :app_category
          item = app_name_category.detect { |inner_item| inner_item.text == what[key] }
        else
          item = nil
          raise "#{key} #{what[key]} not found"
      end
    end

    # finds a study, study group, site, or team
    # @param what [Hash] what to find and its name
    #       select_item(study: 'name')
    def select_item(what)
      get_item(what).click
    end
  end
end
