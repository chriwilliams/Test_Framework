require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Properties < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    # checkbox options
    element :rand_only, '#study_rand_only' #checkbox
    element :ignore_blind, '#study_unblinded' #checkbox
    element :advanced_dosing, '#study_advanced_dosing' #checkbox
    element :site_address, '#study_include_address_in_shipping_email' #checkbox
    element :use_capping, '#study_capping' #checkbox

    # import options
    element :import_design, '#copy_button' #button
    element :import_study, '#study_id_to_copy' #dropdown
    element :modal_continue, '#continue_button' #button
    element :modal_cancel, '#cancel_import_button' #button
    element :modal_import, '#import_button' #button

    # quarantine options
    element :allow_quarantine, '#study_allow_quarantining' #checkbox
    element :quarantine_file_option, '#QR' #dropdown

    # page buttons
    element :save, '#update' #button
    element :remove_test_data, '#flush_data_button' #button
    element :modal_remove_data, '#modal a.positive' #button
    element :reset, '#reset' #button

    # go live
    element :go_live, '#go-live-confirm' #button
    element :delete_data, '.modal-content #delete_yes' #radio button
    element :keep_data, '.modal-content #delete_no' #radio button
    element :confirm_go_live, '.modal-content #confirm_go_live' #button

    # Makes a study Go Live
    # @param preserve [boolean] Option to keep data or flush
    def make_study_go_live(preserve)
      go_live.click
      preserve ? keep_data.click : delete_data.click
      confirm_go_live.click
    end

    # Removes runtime test data
    def remove_runtime_data()
      remove_test_data.click
      modal_remove_data.click
    end

    # Enables quarantining at sites with file options
    # @param file_option [string] file uploading options for sites
    def enable_quarantine(file_option)
      allow_quarantine.set(true)
      quarantine_file_option.select file_option
      save.click
    end

    # Imports a study design
    # @param study [string] the name of the study to import
    def import_study_design(study)
      import_design.click
      modal_continue.click
      import_study.select study
      modal_import.click
    end

    # Enable/Disables Randomization Only
    # @param option [boolean] true or false
    def set_rand_only(option)
      rand_only.set(option)
      save.click
    end

    # Enable/Disables blinding restrictions
    # @param option [boolean] true or false
    def set_blinding_restrictions(option)
      ignore_blind.set(option)
      save.click
    end

    # Enable/Disables Advanced Dosing
    # @param option [boolean] true or false
    def set_advanced_dosing(option)
      advanced_dosing.set(option)
      save.click
    end

    # Enable/Disables Site Address in Shipping Requests
    # @param option [boolean] true or false
    def set_site_address(option)
      site_address.set(option)
      save.click
    end

    # Enable/Disables Capping
    # @param option [boolean] true or false
    def set_capping(option)
      use_capping.set(option)
      save.click
    end
  end
end
