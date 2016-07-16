require_relative 'common_page'

module Mccadmin

  # Elements and methods for 'Manage Users' page
  class ManageUsers < Mccadmin::CommonPage

    section :main_nav, LeftNav, '#sidebar'

    element :users_email, 'tr[id^=user] > td[class=email]'
    element :clear_search, '#clear-search'
    element :add_user_dd, '#add-users-dropdown'
    element :add_new_user, '#add-new-users-for-study'
    elements :all_users, 'div[class=page-header-controls] div ul li'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Search by option and select depending on the identifier
    # @param by [String] the option to search by
    # @param identifier [String] item to search
    def search_and_select_user(by, identifier)
      search.search_by(by, identifier)
      users_email.click if users_email.text.include?(identifier)
    end

  end
end
