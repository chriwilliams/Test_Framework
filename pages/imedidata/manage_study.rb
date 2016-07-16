require_relative '../imedidata/manage_study_group'
require_relative 'sections'

module Imedidata

  class AddSitesLightbox < Common::BaseSection

    element :search_field, '#search_field_search_terms'
    element :search_button, '#search_active_submit'
    element :save_button, '#save_active_submit'
    elements :all_sites, '#add_site_list > tbody > tr'

    # add existing site to the study
    # @param sites [string[]] list of sites
    def add_existing_sites(sites)
      sites.each do |site|
        search_field.set site
        search_button.click
        sleep 1
        found_site = all_sites.detect {|item| item.text.include? site}
        raise "site #{site} was not found" unless found_site
        found_site.all(:css, 'input[id^="page_selection"]').first.set true
        save_button.click
      end
    end
  end

  class ChangeRoleLightbox < Common::BaseSection

    element :role_selector, '#app_assignment_role_ids'
    element :save_button, '#save_roles'

    # adds additional roles (without deselecting current role)
    # @param [string] role to add
    def add_role(role)
      role_selector.select role
      save_button.click
    end

    # unselects role from user
    # @param [string] role to remove
    def remove_role(role)
      role_selector.unselect role
      save_button.click
    end

    # deselects users current role and selects new role
    # @param change_from [string] currently assigned role
    # @param change_to [string] new role to assign
    def change_role(change_from, change_to)
      role_selector.unselect change_from
      role_selector.select change_to
      save_button.click
    end

  end

  class ManageStudy < Imedidata::ManageStudyGroup

    section :header, Header, '#header'
    section :add_sites, AddSitesLightbox, '#new_invitation'
    section :change_role_lightbox, ChangeRoleLightbox, '#new_invitation'
    section :flash_notice, FlashNotice, '#flash-notice'

    # element :upload_csv_link, '#export_and_upload > a'
    element :upload_csv_link, 'a[href$="file_uploads/new"]'
    # element :upload_button, '#upload_active_submit'
    element :upload_button, '#upload'
    element :add_sites_button, '#add_sites'

    elements :all_users, '#pane_data > div.list_content > table > tbody > tr'
    elements :assign_site, 'a[id$=_assign_sites]'
    set_url_matcher /.imedidata./

    # initialize page
    def initialize
      super
    end

    # upload csv with user data
    # @param filepath [string] file path
    def upload_csv(filepath)
      upload_csv_link.click
      upload_file('file_upload_file_upload', filepath)
      upload_button.click
      sleep 10
      refresh_browser
      sleep 10
    end

    # open course override lightbox for specified user
    # @param user [string] user
    def open_course_override(user)
      user_row = all_users.detect { |item| item.text.include? user }
      sleep 5 #Wait for the elements
      begin
        if user_row.visible?
          link = user_row.find_link('1 Course')
          if link.nil? && !link.visible?
            raise "No link for courses found with #{link.text}"
          else
            if link.visible?
              link.click
              true
            else
              refresh_browser unless flash_notice.visible?
              link.click if link.visible?
              true
            end
          end
        end
      rescue Capybara::ElementNotFound
        false
      end
    end

    # verify app and role assignment settings for specified user
    # @param data [hash] data
    # @option Login [string] username
    # @option app_roles [hash] apps and roles
    # @option app [string] app
    # @options role [string] role
    def verify_role_asgn_status(data)
      sleep 3
      data.each do |row|
        user_row = all_users.detect { |item| item.text.include? row['Login'] }
        sleep 3
        puts user_row.text
        if user_row.nil?
          raise "No user found with login #{row['Login']}"
        else
          row['apps_roles'].each do |item|
            raise "User #{row['Login']} doesn't have correct Apps and role assignment" unless user_row.text.include? item
          end
          raise "User #{row['Login']} doesn't have correct status" unless user_row.text.include? row['Status']
        end
      end
    end

    # Go to add sites
    def go_to_add_sites
      add_sites_button.click
    end

    # change role for specified user
    # @param user [string] user
    # @param data [hash]
    # @option app_role [hash]
    # @option app [string] app
    # @option role [string] role
    def change_role(user, data)
      user_row = all_users.detect { |item| item.text.include? user }
      data.each do |app_role|
        user_row.find_link(app_role['App']).click
        change_role_lightbox.change_role(app_role['Role'], app_role['NewRole'])
      end
    end

    # finds and clicks the link to bring up the assign roles lightbox
    # @param user [string] user
    # @param data [hash] contains app and role information
    def add_role(user, data)
      user_row = all_users.detect { |item| item.text.include? user }
      data.each do |app_role|
        user_row.find_link(app_role['App']).click
        change_role_lightbox.add_role(app_role['Role'])
      end
    end

    # Click assign sites button for a user
    # @param user [string] user you are assigning to site
    def click_assign_site(user)
      user_row = all_users.detect { |item| item.text.include? user }
      sleep 2 #Wait for the elements
      link = assign_site.first
      link.click
    end

  end
end
