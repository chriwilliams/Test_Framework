require_relative 'common_page'

module Mccadmin

  class AllUsers < Mccadmin::CommonPage

    element :view_all_studies, '#all-studies-nav-btn'
    element :create_admin_user, '#create-admin-user'
    element :remove_user, 'a[id^=remove-user]'
    element :remove_user_confirm, 'a[id^=remove-client-division-user-confirm]'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Clicks create admin user button
    def click_create_admin_user
      create_admin_user.click
    end

    # Clicks view all studies button
    def click_view_all_studies
      view_all_studies.click
    end

    # Clicks remove user from client division link
    def remove_client_division_user
      using_wait_time 10 do
        remove_user.click
        remove_user_confirm.click
      end
    end

  end
end