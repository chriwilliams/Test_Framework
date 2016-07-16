require_relative 'common_page'

module Mccadmin

  # Create Study Page
  class CreateStudy < Mccadmin::CommonPage

    element :study_protocol_id, '#study_protocol_id'
    element :use_protocol_id_checkbox, '#use-protocol-id'
    element :study_name, '#study_name'
    element :primary_indication, 'div[id$=primary_indication] > a'
    element :secondary_indication, 'div[id$=secondary_indication] > a'
    element :study_phase, '#study_phase_uuid'
    element :study_configuration_type, '#study_configuration_type_uuid'
    element :test_study_checkbox, '#test_study'
    element :create_study_submit_button, '#create-study-submit'
    element :search_primary_indication, '#s2id_autogen1_search'
    element :search_secondary_indication, '#s2id_autogen2_search'

    elements :primary_indication_list, '#select2-results-1 > li'
    elements :secondary_indication_list, '#select2-results-2 > li'

    element :save_btn, '#edit-study-submit'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Creates a Study
    # @param [Hash] params containing all required parameters to create a study
    # @option params [String] 'study_protocol_id' Protocol ID of the study
    # @option params [Boolean] 'use_protocol_id'
    # @option params [String] 'study_name' Name of the study
    # @option params [String] 'Primary Indication' Primary Indication of the study
    # @option params [String] 'study_phase' Phase of the study
    # @option params [String] '' Name of the study
    # @option params [String] 'study_name' Name of the study
    def create_study(params = {})
      study_protocol_id.set params['study_protocol_id']
      use_protocol_id_checkbox.set(false) if params['use_protocol_id'].downcase.include?('false')
      study_name.set params['study_name']
      set_primary_indication(params['primary_indication'])
      set_secondary_indication(params['secondary_indication']) unless nil_or_empty?(params['secondary_indication'])
      study_phase.select params['study_phase']
      study_configuration_type.select params['study_configuration_type'] unless params['study_configuration_type'].nil?
      test_study_checkbox.set(true) if params['test_study'].downcase.include?('true')
      create_study_submit_button.click
    end

    # Sets primary indication
    # @param [String] indication
    def set_primary_indication(indication)
      primary_indication.click
      search_primary_indication.set indication
      option = primary_indication_list.detect { |item| item.text.include? indication }
      raise "No indication found as #{indication}" if option.nil?
      option.click
    end

    # Sets secondary indication
    # @param [String] indication
    def set_secondary_indication(indication)
      secondary_indication.click
      search_secondary_indication.set indication
      option = secondary_indication_list.detect { |item| item.text.include? indication }
      raise "No indication found as #{indication}" if option.nil?
      option.click
    end

    def update_study_name(name)
      study_name.set name
      save_btn.click
    end

  end

end
