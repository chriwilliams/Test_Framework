require_relative 'common_page'

module Mccadmin

  class RenameConfigurationModal < Common::BaseSection

    element :modal_header, '#configuration-type-name-update-label'
    element :name_input, '#configuration_type_name'
    element :submit, '#configuration-type-submit'
    element :cancel, '#configuration-type-cancel'

    # Setter method to set the name
    # @param name [String]
    def set_ct_name(name)
      self.wait_for_modal_header
      name_input.set(name)
      submit.click
    end

  end

  class RolesConfiguration < Mccadmin::CommonPage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'
    section :main, Main, '#main'
    section :rename_modal, RenameConfigurationModal, '#configuration-type-name-update > div'

    element :configuration_action_button, 'button[id^=configuration]'
    elements :configuration_actions, 'tr[id^=configuration] > td > div >ul >li > a'

    set_url_matcher /.dalton./

    def initialize
      super
    end

    # Renames the configuration type name
    # @param name [String] containing the new name
    def rename_config_type(name)
      select_configuration_action('Rename')
      rename_modal.set_ct_name(name)
    end

    # Selects the action for the configuration type
    # @param action [String] matches and selects the action provided
    def select_configuration_action(action)
      configuration_action_button.click
      option = configuration_actions.detect { |inner_item| inner_item.text.include? action }
      option.click
    end

  end

end