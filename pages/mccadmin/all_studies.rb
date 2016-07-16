require_relative 'common_page'
require_relative 'manage_studies'

module Mccadmin

  # Elements and methods for 'All Studies' page
  class AllStudies < Mccadmin::CommonPage

    section :esign_frame, EsignatureFrame, '.login_form > fieldset'
    section :main_nav, LeftNav, '#sidebar'

    elements :studies_name, '#study-list td[class^=name]'
    element :create_study_button, '#create-study'
    element :view_all_users_button, '#all-users-nav-btn'
    element :export_list, '#export'
    element :study_settings_button, 'button[id^=study]'
    element :study_unlock_reason, 'select[id=unlock_study_speedbump]'
    element :study_submit_button, 'button[id$=study-submit]'
    element :esignature_modal, 'div[id=esignature] > div > div'
    elements :study_settings, 'tr[id^=study] > td > div >ul >li > a'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Click on 'Create Study'
    # @param create_study_params [hash] hash containing all parameters
    def click_create_study
      create_study_button.click
    end

    # Search for a study
    # @param by [string] search classification (All, Name, Protocol ID, Phase, Indication)
    # @param identifier [string] search term
    # @returns index of study in the study list table
    def search_study(by, identifier)
      search.search_by(by, identifier)
      get_element_index(studies_name, identifier, false)
    end

    # Select a particular study from search results
    # @param by [string] search classification (All, Name, Protocol ID, Phase, Indication)
    # @param identifier [string] search term
    def search_and_select_study(by, identifier)
      index = search_study(by, identifier)
      studies_name[index].click
    end

    # Selects the settings action for the study
    # @param action [String] matches and selects the action provided
    def select_study_settings(action)
      if action == 'deactivate'
        action = 'make inactive'
      end
      study_settings_button.click
      self.wait_for_study_settings
      option = study_settings.detect { |inner_item| inner_item.text.downcase.include? action }
      raise "No such action setting found as #{action}" if option.nil?
      option.click
    end

    # Performs lock/unlock/activate/deactivate and esign.
    # @param action [String]
    # @param username[String]
    # @param password[String]
    def perform_action_and_esign(action, username, password)
      case action.downcase
        when 'lock'
          click_submit_and_esign(username, password)
        when 'unlock'
          study_unlock_reason.select("Data change which could impact the key efficacy endpoint")
          click_submit_and_esign(username, password)
        when 'deactivate'
          click_submit_and_esign(username, password)
        when 'activate'
          self.wait_for_study_submit_button
          study_submit_button.click
        else
          raise "No such action as #{action} found!"
      end
    end

    def click_submit_and_esign(username, password)
      self.wait_for_study_submit_button
      study_submit_button.click
      self.wait_until_esignature_modal_visible
      page.driver.browser.switch_to.frame("esignature-page")
      esign_frame.provide_esign(username, password)
      self.wait_until_esignature_modal_invisible
    end

  end
end