require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class ManageUsers < Common::BasePage

    section :header, Header, '#header'

    element :email_addresses, '#invitation_detail_invitees'
    element :is_owner, '#invitation_detail_owner'
    element :invite_button, '.invite_button [type="submit"]'
    element :add_new_app, '#add_another_app_link'
    element :app_drop_down, 'select[id$="app_id"]'
    element :role_drop_down, 'select[id$="role_ids_"]'
    element :site_drop_down, 'select[id$="study_site_id"]'

    set_url_matcher /.imedidata./

    # invite user to study or study group
    # @param param [hash]
    # @option email [string] user email
    # @option isowner [bool] is owner?
    # @option apps [string] apps
    # @option roles [string] roles
    # @option sitename [string] sites
    def invite_user(param)
      email_addresses.set param[:email]
      is_owner.set(true) if param[:owner] == 'true'
      unless nil_or_empty?(param[:apps])
        param[:apps].each_with_index do |item, index|
          app_drop_down.select item
          role_drop_down.select param[:roles][index] if param[:roles]
          site_drop_down.select param[:sites][index] if param[:sites]
          add_new_app.click
        end
      end
      invite_button.click
    end

  end
end
