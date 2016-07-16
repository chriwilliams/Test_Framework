require_relative 'common_page'

module Mccadmin

  class AddUserToClientDivision < Mccadmin::CommonPage

    element :user_email, '#user_email'
    element :user_first_name, '#user_first_name'
    element :user_last_name, '#user_last_name'
    element :phone, '#user_telephone'
    element :role_row, 'div[class$="roles-group"]  > div > a'
    element :role_dd, 'select[id=role-uuid]'
    element :add_button, '#add-user-submit'
    element :cancel_button, '#add-user-cancel'

    elements :role_options, '#select2-results-1 > li > div'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Adds an admin user using the defined params
    # @param params [Hash] parameter used to create a user
    # option params [String] :email Email of the user
    # option params [String] :first First Name of the user
    # option params [String] :last Last Name of the user
    # option params [String] :phone Phone number of the user
    # option params [String] :role Role of the user
    def add_user(params = {})
      user_email.set(params[:email])
      user_first_name.set(params[:first])
      user_last_name.set(params[:last])
      phone.set(params[:phone]) if params[:phone]
      select_role(params[:role])
      sleep 2
      add_button.click
      sleep 5
    end

    private

    # Selects a role
    def select_role(role)
      role_row.click
      role_options.each do |item|
        if item.text.include?(role)
          item.click
          break
        end
      end
    end

  end
end