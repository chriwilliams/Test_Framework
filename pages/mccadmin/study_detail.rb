require_relative 'common_page'

module Mccadmin

  # Elements and methods for 'Study Detail page'
  class StudyDetail < Mccadmin::CommonPage

    section :esign_frame, EsignatureFrame, '.login_form > fieldset'
    section :main_nav, LeftNav, '#sidebar'

    element :protocol_id, '#study_protocol_id'
    element :name, '#study_name'
    element :primary_indication, '#primary_indication'
    element :secondary_indication, '#secondary_indication'
    element :phase, '#study_phase_uuid'

    element :configuration_type, '#study_configuration_type_uuid'
    element :use_protocol_id, 'input[id=use-protocol-id]'
    element :test_study, 'input[id=test_study][type=checkbox]'
    element :save_button, '#edit-study-submit'
    element :cancel_button, '#edit-study-cancel'
    element :lock_button, 'a[id^=lock-study]'
    element :unlock_button, 'a[id^=unlock-study]'
    element :activate_button, 'a[id^=activate-study]'
    element :inactivate_button, 'a[id^=deactivate-study]'
    element :submit_button, 'a[id$=submit]'
    element :modal_submit_button, '.modal-footer > button[id$=study-submit]'
    element :esignature_modal, 'div[id=esignature] > div > div'

    element :study_detail_primary_indication_container, '#select2-chosen-1'
    element :study_detail_primary_indication_input_field, '#primary_indication'
    elements :study_detail_primary_indication_results, 'div[id^="select2-result-label"]'

    element :study_detail_secondary_indication_container, '#select2-chosen-2'
    element :study_detail_secondary_indication_input_field, '#secondary_indication'
    elements :study_detail_secondary_indication_results, 'div[id^="select2-result-label"]'


    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Performs Lock study.
    # @param username[String]
    # @param password[String]
    def lock_study(username, password)
      lock_button.click
      self.wait_for_modal_submit_button
      modal_submit_button.click
      self.wait_until_esignature_modal_visible
      page.driver.browser.switch_to.frame("esignature-page")
      esign_frame.provide_esign(username, password)
      self.wait_until_esignature_modal_invisible
    end

    def activate_study
      activate_button.click
      self.wait_for_modal_submit_button
      modal_submit_button.click
    end

    def use_protcol_id(value = true)
      protocol_id.set(value)
      self.wait_for_save_button
      save_button.click
    end


    def set_test_study(value = true)
      test_study.set(value)
      self.wait_for_save_button
      save_button.click
    end

    # Update Study providing specific information
    # @param data: Optional pattern designed to pass selective information to method
    # - Optional parameters:
    #   ** @param [Protocol Id]
    #   ** @param [Name]
    #   ** @param [Phase]
    #   ** @param [Test Study]
    #   ** @param [Primary Indication]
    #   ** @param [Secondary Indication]
    #   ** @param [Configuration Type]
    def update_study(data = {})

      raise Capybara::ExpectationNotMet, "No information was given to update study" if data.empty?

      protocol_id.set(data['Protocol Id']) if data.has_key? 'Protocol Id'
      name.set(data['Name']) if data.has_key? 'Name'
      phase.select(data['Phase']) if data.has_key? 'Phase'
      configuration_type.select(data['Configuration Type']) if data.has_key? 'Configuration Type'

      test_study.set(data['Test Study']) if data.has_key? 'Test Study'


      data.select { |key, value| ['Primary Indication', 'Secondary Indication'].include? key }.each do |key, value|
        self.send("study_detail_#{key.parameterize('_').downcase}_container".to_sym).click
        self.send("study_detail_#{key.parameterize('_').downcase}_input_field".to_sym).set(value)
        self.send("study_detail_#{key.parameterize('_').downcase}_results".to_sym).first.click
      end

      self.wait_for_save_button
      save_button.click
    end

    #TODO: Unlock and Deactivate methods, make it common if possible

    # @param field [String|Hash] String: locator name, Hash: {field => {key: value, key1: value1, ...}}
    # @param tag [String] an element type in locator
    # @example "Save": "button": "selector", "element"
    # @param value [String] current value of the field
    # @return [Boolean]
    def has?(field, tag=nil, value=nil)
      case field
        when Hash
          field.each_pair do |key, details|
            has_field?(SELECTOR_MAPPING[STUDY_DETAIL][key][details[:tag]][SELECTOR], details[:value]) do |css, value|
              expected(key, details[:type], details[:value]) unless has_value?(css, value)
            end
          end
        when String
          has_field?(SELECTOR_MAPPING[STUDY_DETAIL][field][tag][SELECTOR], value) do |css, value|
            expected(field, tag, value) unless has_value?(css, value)
          end
        else
          raise Capybara::ExpectationNotMet, "unexpectation field type: expecting Hash or String, got #{field.class}"
      end
    end

    private

    def has_field?(css, value=nil)
      (block_given? and value) ? yield(css, value) : page.has_css?(css)
    end

    def has_value?(css, value)
      page.find(css).value == value
    end

    def expected(field, tag, value)
      css = SELECTOR_MAPPING[STUDY_DETAIL][field][tag][SELECTOR]
      raise Capybara::ExpectationNotMet, %Q{expected field "#{field}" to have value "#{value}". got "#{find(css).value}"}
    end
  end
end
