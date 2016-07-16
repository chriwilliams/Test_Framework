require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'

module Imedidata
  class Search < Common::BaseSection
    element :text, 'input#search_field_search_terms'
    element :link, 'a[id$="_search_submit"]'
  end

  class Home < Common::BasePage

    section :header, Header, 'header#header'

    elements :studies_as_row, 'div#studies div[class^="study study_row"] a[id^="study_"]'
    elements :study_groups_as_row, 'div#studies div[class^="study_group study_row"] a[id^="study_group_"]'
    elements :study_apps_as_row, 'div#studies div[class^="study study_row"] a[href="/?study_id=]'

    element :studies_link, 'a#studies_list_link'
    element :teams_link, 'a#teams_list_link'
    element :sites_link, 'a#sites_list_link'
    element :next, 'a.next_label'
    element :prev, 'a.previous_label'
    element :account_details, 'a[id="Edit Profile"]'
    element :mymedidata, 'a[href="http://www.mymedidata.com"]'
    element :admin, 'Admin'

    section :studies_search, Search, 'div.search > form#studies_search'
    section :sites_search, Search, 'div.search > form#sites_search'
    section :teams_search, Search, 'div.search > form#teams_search'

    set_url_matcher /.imedidata./

    attr_reader :my_title

    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
      @my_title = 'iMedidata'
    end

    def verify_page
      super(@my_title, nil)
    end

    # @param by [:Symbol] what kind of search. options => :study, :site, or :team
    # @param what [String] the name for what to search
    def search_by (by, what)
      search = case by
                 when :study;
                   studies_search
                 when :site;
                   sites_search
                 when :team;
                   teams_search
                 else
                   return
               end
      search.text.set what
      search.link.click
    end

    # clicks the study, study_group, site, team or app
    # @param what [Hash] study|study_group|site|team|app: 'name'
    #             e.g. select (study: 'study_name')
    # @param for_what [Hash] for when 'what' is 'app', 'for_what' describes the app for study|study_group|site|team: 'name'
    #             e.g. select (app: 'app name', {study: 'study name'})
    def select(what, for_what=nil)
      for_what ? select_app(what[:app], for_what) : select_item(what)
    end

    # finds a study, study group, site, or team
    # @param what [Hash] what to find and its name
    #       find_item(study: 'name')
    # @return [Object]
    def find_item(what)
      key = what.keys[0]
      item = case key
               when :study
                 item = studies_as_row.detect { |inner_item| inner_item.text == what[key] }
               when :study_group
                 item = study_groups_as_row.detect { |inner_item| inner_item.text == what[key] }
               when :site
                 item = sites_as_row.detect { |inner_item| inner_item.text == what[key] }
               when :team
                 item = teams_as_row.detect { |inner_item| inner_item.text == what[key] }
               else
                 nil
             end
      return item
    rescue => e
      raise "#{key} #{what[key]} not found"
    end

    private

    # @param what [Hash] study|study_group|site|team|app: 'name'
    def select_item(what)
      find_item(what).click
    end

    # clicks an app for a study, study_group, site or team
    # @param app [String] the app name
    # @param for_what [Hash] for when 'what' is 'app', 'for_what' describes the app for study|study_group|site|team: 'name'
    #             e.g. select_app ('app name', {study: 'study name'})
    def select_app(app, for_what)
      item = find_item(for_what)
      find_app(for_what, item, app).click
    end

    # finds the app of a study, study group, site or team
    # @param what [Symbol] :study, :study_group, :site, :team
    # @param item [Object] result of find_item
    def find_app(what, item, app)
      id = get_id(what, item)
      the_app = get_app(what, app, id)
      raise "#{what} #{item['text']} app #{app} not found" unless the_app
      the_app
    end

    def get_id(what, item)
      case what.keys[0]
        when :study
          /^study_(?<s_id>\d+)_manage_link$/.match(item['id'])[:s_id]
        when :study_group
          /^study_group_(?<sg_id>\d+)_manage_link$/.match(item['id'])[:sg_id]
        when :site
          raise "don't know how to search for site id"
        when :team
          raise "don't know how to search for team id"
        else
          nil
      end
    end

    def get_app(what, app, id)
      apps = all(case what.keys[0]
                   when :study
                     %Q{div.app a[href*="/?study_id=#{id}"]}
                   when :study_group
                     %Q{div.app a[href*="/?studygroup_id=#{id}"]}
                   when :site
                     raise "don't know how to search for site apps"
                   when :team
                     raise "don't know how to search for team apps"
                   else
                     nil
                 end)
      apps.detect { |a| a['text'] == app }
    end
  end
end