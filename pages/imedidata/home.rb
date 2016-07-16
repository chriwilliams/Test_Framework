require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'
require_relative 'course'

module Imedidata

  # Studies Search Section
  class Search < Common::BaseSection
    element :text, 'input#search_field_search_terms'
    element :link, 'a[id$="_search_submit"]'
  end

  # TODO: Deprecated - Remove when all instances replaced with Invites Section
  class Invitations < Common::BaseSection

    element :study_name, 'span[class=join] > b'
    element :inv_accept, 'span > a[id^=accept]'
    element :inv_decline, 'span > a[id^=decline]'

  end

  class Invites < Common::BaseSection

    elements :study_names, '#pending_invitations_container b'
    elements :accept_invs, '#pending_invitations_container a[id^=accept]'
    elements :decline_invs, '#pending_invitations_container a[id^=decline]'


    # Accepts or Declines an invite
    # @param invite_name [string] name of the study or study group invite
    # @param accept [boolean] true or false to accept or decline
    def acknowledge_invite(invite_name, accept=true)
      if $sticky.has_key? invite_name.to_sym
        invite_name = $sticky[invite_name.to_sym]
      else
        invite_name = $helpers.randomize_arg(invite_name)
      end
      index = get_element_index(study_names, invite_name)
      accept ? accept_invs[index].click : decline_invs[index].click
    end

  end

  # Elements and Methods for iMedidata Home page
  class Home < Common::BasePage

    section :header, Header, '#header'
    section :studies_search, Search, 'div.search > form#studies_search'
    section :sites_search, Search, 'div.search > form#sites_search'
    section :teams_search, Search, 'div.search > form#teams_search'
    section :notifications, Notifications, '#notifications'
    section :flash_notice, FlashNotice, '#flash-notice'
    sections :invitations, Invitations, 'div[id^=pending] > div[id*=invitation_]'
    section :invites, Invites, '#tasks_container'

    elements :all_studies, 'div.study.study_row'
    elements :all_study_groups, '#studies div.study_box'
    elements :studies_as_row, 'div#studies div.studies_as_study_row div.study.study_row div.context_link a[id^="study_"]'
    elements :studies_links_as_row, 'div#studies div.study.study_row div.app_launcher div.app a'
    elements :study_groups_as_row, 'div#studies div[class^="study_group study_row"] a[id^="study_group_"]'
    elements :study_apps_as_row, 'div#studies div[class^="study study_row"] a[href="/?study_id=]'
    elements :apps_in_search_result, 'div[class="app"] a[href*="study"]'
    elements :studies_in_search_result, 'div[class*="studies"] a[href*="studies"]'
    elements :study_groups_in_search_result, 'div[class*="study_group"] a[href*="study_group"]'
    elements :course_link, 'div.app a'

    element :search_results, '#studies_container'
    element :elearning_link, '#elearning_courses_count > a'
    element :studies_link, 'a#studies_list_link'
    element :teams_link, 'a#teams_list_link'
    element :sites_link, 'a#sites_list_link'
    element :next_label, '#studies a.next_label'
    element :prev_label, 'a.previous_label'
    element :pagination_label, 'div.imedidata-pagination'
    element :account_details, 'a[id="Edit Profile"]'
    element :mymedidata, 'a[href="http://www.mymedidata.com"]'
    element :admin, 'Admin'
    element :esign_username, '#username'
    element :esign_password, '#password'
    element :esign_button, '#create_session_link'
    element :search_result_study_container, 'div[class*="study_group study_box"]'


    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
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
      sleep 1 # Letting the search results load
    end

    # clicks the study, study_group, site, team or app
    # @param what [Hash] study|study_group|site|team|app : name
    # @param for_what [Hash] Parent Attibute. e.g. To select app app_name from study study_name use
    def select(what, for_what=nil)
      for_what ? select_app(what[:app], for_what) : select_item(what)
    end

    # finds a study, study group, site, or team
    # @param what [Hash] what to find and its name
    #       find_item(study: 'name')
    # @return [Object]
    def find_item(what)
      key = what.keys[0]
      app_key = what.keys.count > 0 ? what.keys[1] : nil
      option_key = what.keys.count > 1 ? what.keys[2] : nil
      attempts = 10

      # The code below will ensure against stale exception. It will attempt 10 times and exit. We may add other exception as they occur.
      $async::wait_with_retries(errors: Selenium::WebDriver::Error::StaleElementReferenceError, timeout: 0.01, attempts: attempts) do
        case key
          when :study
            items = all_studies.detect { |inner_item| inner_item.text.include? what[key] } if all_studies.count > 0
            item = items.find('div.context_link a[id^="study_"]') if items
          when :study_link
            items = all_studies.detect { |inner_item| inner_item.text.include? what[key] } if all_studies.count > 0
            item = items.find('div.app_launcher div.app a') if items
          when :study_group
            item = study_groups_as_row.detect { |inner_item| inner_item.text == what[key] }
          when :app_launcher
            unless (option_key && what[option_key] =~ /study group/i)
              items = all_studies.detect { |inner_item| inner_item.text.include? what[key] } if all_studies.count > 0
            else
              items = all_study_groups.detect { |inner_item| inner_item.text.include? what[key] } if all_study_groups.count > 0
            end

            item = items.all('div.app_launcher div.app a', text: app_key.nil? ? '' : what[app_key])[0] if items
          when :site
            item = sites_as_row.detect { |inner_item| inner_item.text == what[key] }
          when :team
            item = teams_as_row.detect { |inner_item| inner_item.text == what[key] }
          else
            item = nil
            raise "#{key} #{what[key]} not found"
        end
        item
      end
    end

    # selects a study, study group, site, or team
    # @param what [Hash] what to find and its name
    #       select_item(study: 'name')
    def select_item(what)
      item = find_item(what)
      item.click if item
    end

    def select_item_in_view(what)
      until (item = find_item(what) )
        # sleep 1
        go_to_next_page
      end
      item.click if item
    end

    # Select item from Search Results
    def select_item_from_search_results(item_name)
      item_name.strip! if item_name.is_a? String
      item = search_results.find_link(item_name)
      if item.visible?
        item.click
      else
        raise "#{item_name} doesn't exist in search results"
      end
    end

    # TODO: Deprecated - Remove when all instances replaced with new Invites Section
    # Accept or decline invite for study or study group depending on params
    # @param [Hash] params used to accept or decline the invitations for study or study group
    # option params [String] :invitations
    def accept_or_decline_invitation(params = [])
      study_invites = array_of_study_invite(params)
      while study_invites.size > 0 do
        study_invites.each do |option|
          if invitations.first.study_name.text.include?(option.first) && option.last.downcase.include?('accept')
            invitations.first.inv_accept.click
            sleep 5
            study_invites.shift unless study_invites.empty?
            break
          elsif invitations.first.study_name.text.include?(option.first) && option.last.downcase.include?('decline')
            invitations.first.inv_decline.click
            sleep 5
            study_invites.shift unless study_invites.empty?
            break
          end
        end
      end
    end

    def select_item_by_partial_match(item_type, item_name)
      case item_type
        when :app
          item = apps_in_search_result.detect { |inner_item| inner_item.text.match item_name }
        when :study
          item = studies_in_search_result.detect { |inner_item| inner_item.text.match item_name }
        when :study_group
          item = study_groups_in_search_result.detect { |inner_item| inner_item.text.match item_name }
        else
          raise "Allowed item types are: :app, :study and :study_group"
      end
      if item
        item.click
      else
        raise "item #{item_name} doesn't exist in search results"
      end
    end

    # Completes a particular course provided and esigns
    # @param link [String] link for the course
    # @param [Hash] params required to esign
    # @option params [String] :username the username
    # @option params [String] :password the password
    def complete_course_and_esign(link, params = {})
      click_course_link(link) #TODO: Make clicking link dynamic, as of now its clicking the first one ~MD
      sleep 5 #Wait for the course window to appear
      windows = page.driver.browser.window_handles
      if windows.size > 1
        page.driver.browser.switch_to.window(windows[1])
        page.driver.browser.switch_to.frame("contentframe")
        course = Course.new
        course.browse_course
        page.driver.browser.switch_to.window(windows[0])
        course_esignature(params)
      else
        course_esignature(params)
      end
    end

    def click_course_link(course_name)
      link = course_link.detect { |course| course.text == course_name }

      if link != nil
        link.click
      else
        raise "Your course #{course_name} was not found."
      end
    end


    # Perform esignature sign up after course completion
    # @param [Hash] params required to esign
    # @option params [String] :username the username
    # @option params [String] :password the password
    def course_esignature(params = {})
      page.driver.browser.switch_to.frame("esignature_iframe")
      esign_username.set(params[:username])
      esign_password.set(params[:password])
      esign_button.click
    end

    # Clicks the elearning link in the home page
    def go_to_elearning_page
      elearning_link.click
      sleep 5
    end

    def go_to_next_page
      if pagination_label.text =~ /^.*(\d+)\s+of\s+(\d+).*$/
        next_label.click if (res = ($1.to_i < $2.to_i))
        return res
      else
        return false
      end
    rescue
      return false
    end
    
    # navigates to study group page for a study group within iMedidata by looking through the table
    # @param sg [String] name of study group
    def go_to_sg(sg)
      search_by(:study, sg)
      within(search_result_study_container) do
        find_link(sg).click
      end
    end

    def get_apps_list
      apps = []
      if apps_in_search_result
        apps_in_search_result.each do |app|
          apps << app.text
        end
      else
        apps = nil
      end
      apps
    end

    private

    # clicks an app for a study, study_group, site or team
    # @param app [String] the app name
    # @param for_what [Hash] describes which app to choose
    # @option for_what [string] :study the study name
    # @option for_what [string] :site the site name
    # @option for_what [string] :study_group the study group
    # @option for_what [string] :team the team name
    # @example selecting a study
    #   select_app ('app name', {study: 'study name'})
    def select_app(app, for_what)
      item = find_item(for_what)
      find_app(for_what, item, app).click
    end

    # finds the app of a study, study group, site or team
    # @param what [Hash] describes which app to find
    # @option what [string] :study the study name
    # @option what [string] :site the site name
    # @option what [string] :study_group the study group
    # @option what [string] :team the team name
    def find_app(what, item, app)
      id = get_id(what, item)
      the_app = get_app(what, app, id)
      raise "#{what} #{item['text']} app #{app} not found" unless the_app
      the_app
    end

    # Retreve the id from html attribute
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

    # Find app with a particular id and name
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

    # TODO: Deprecated - Remove when all instances replaced with new Invites Section
    #Returns an array of arrays containing study with concatenated environment and invitation
    def array_of_study_invite(params=[])
      study_invite =[]
      params.each do |param|
        if param[:environment]
          if param[:environment].size <= 1
            studies = concat_environment(param[:name], param[:environment].first)
            study_invite << Array[studies, param[:invitation].first]
          else
            param[:environment].each_with_index do |env, index|
              studies = concat_environment(param[:name], env)
              study_invite << Array[studies, param[:invitation][index]]
            end
          end
        else
          study_invite << Array[param[:name], param[:invitation].first]
        end
      end
      study_invite
    end

    # Concatenate the study environment with the study name and return the concatenated result
    # @param [Hash] params contains the hash of study name and environments
    # @option params [String] :name
    # @option params [String] :environment
    # @return [Array<String>]
    def concat_environment(name, environment)
      study_with_env = case environment
                         when "DEV", "UAT", "TRAIN", "OTHER"
                           "#{name} (#{environment})"
                         else
                           name
                       end
      study_with_env.strip
    end

    # Concatenate the study environment with the study name and return the concatenated result
    # @param [Hash] params contains the hash of study name and environments
    # @option params [String] :name
    # @option params [String] :environment
    # @return [Array<String>]
    def concat_environment(name, environment)
      study_with_env = case environment
                         when "DEV", "UAT", "TRAIN", "OTHER"
                           "#{name} (#{environment})"
                         else
                           name
                       end
      study_with_env.strip
    end
  end
end
