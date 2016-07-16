require_relative '../common/base_section'

module Imedidata
  class Header < Common::BaseSection

    element :logout_link, '#logout'
    element :home_button, '#header div.logos a.mcc-logo'
    element :admin_link, 'a[href*="admin"]'
    element :edit_user_link, '#username'
    element :helpdesk_link, 'a[href*="help_desk"]'
    element :user_name, '#user.btn-group a[data-toggle="dropdown"]'
    element :user_dropdown, '#user.btn-group #user-dropdown'
    element :help_link, '#help.btn-group a.dropdown-toggle'
    element :help_dropdown, '#help.btn-group ul.dropdown-menu'

    # CLicks the logout link
    def logout
      user_name.click
      logout_link.click
    end

    # CLicks the home button
    def go_home
      wait_for_home_button
      home_button.click
    end

    # Clicks the admin button
    def go_to_admin_page
      user_name.click
      admin_link.click
    end

    def get_edit_user_link
      edit_user_link.text
    end

    # Clicks the Helpdesk link
    def go_to_helpdesk_page
      edit_user_link.click
      helpdesk_link.click
    end

  end

  class FlashNotice < Common::BaseSection

    element :flash_text, '.flash-text'

    #returns flash message
    def get_message
      flash_text.text
    end

  end


  class TabNavigation < Common::BaseSection

    element :studies_tab, 'a[href$="studies"]'
    element :users_tab, 'a[href$="users"]'
    element :depots_tab, 'a[href$="depots"]'
    element :elearning_tab, 'a[href$="elearning"]'
    element :custom_email_tab, 'a[href$="custom_email"]'
    element :sites_tab, 'a[href$="sites"]'
    element :create_new_study, '#create_new_study'
    element :add_sites, '#add_sites'
    element :create_new_site, '#create_sites'

    def click_tab(option)
      tab = case option
              when :studies
                studies_tab
              when :users
                users_tab
              when :sites
                sites_tab
              when :elearning
                elearning_tab
              else
                nil
            end
      raise "No tab as #{option} found!" if tab.nil?
      tab.click if tab.visible?
    end
  end

  class Notifications < Common::BaseSection
    elements :all_messages, 'div[id*="notification_"]'

    # verify flash notification message
    # @param exp_msg_text [string] expected message text
    def verify_notification(exp_msg_text)
      msg_found = false
      all_messages.each do |msg|
        if msg.text.include? exp_msg_text
          msg_found = true
        end
        msg.find_link('Close Message').click
      end
      raise "Message '#{exp_msg_text}' not found" unless msg_found
    end

    def clear_notification
      unless all_messages.empty?
        all_messages.each do |msg|
          msg.find_link('Close Message').click
        end
      end
    end
  end

end
