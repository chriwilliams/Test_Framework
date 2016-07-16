require_relative 'home'
require_relative '../common/base_modal_dialogs'
require_relative 'study_design_section'

module StudyDesign
  class ScenarioAction < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Scenario Action']['Rename']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Scenario Action']['Rename']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Scenario Action']['Export']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Scenario Action']['Export']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Scenario Action']['Delete']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Scenario Action']['Delete']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Scenario Action']['Copy']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Scenario Action']['Copy']['button'][$janus::SELECTOR]

  end
  class ActiveScenario < ScenarioTab
    set_url_matcher /.\/scenarios*/

    def initialize
      @klass = ACTIVE_SCENARIO
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The active scenario was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    section SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['section'][ELEMENT].to_sym, ScenarioAction, SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['section'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVE_SCENARIO]['Tab']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCENARIO]['Tab']['label'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['button'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['dropdown'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['list'][SELECTOR]


    # Method: invoke_action, invokes various actions provided though hash methods
    # @param: opt [Hash] takes 0 or more parameters.
    def invoke_action(opt = {})
      action_hash = SELECTOR_MAPPING[ACTIVE_SCENARIO][opt['action'].capitalize.gsub(/(Rename|Delete|Export|Copy).*$/, '\1')] || {}
      click_on_button('Action', 'button', ACTIVE_SCENARIO)
      self.send("wait_until_#{SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['dropdown'][ELEMENT]}_visible")

      self.send("#{SELECTOR_MAPPING[ACTIVE_SCENARIO]['Action']['section'][ELEMENT]}").invoke_click(opt['action'].downcase.gsub(/(rename|delete|export|copy).*$/, '\1'), 'Scenario Action')

      Common::ModalDialog::InputDialog.new(
          'div.modal-dialog',
          LOCALES_MAPPING[$janus.locale]['SCENARIO']['RENAME_SCENARIO_TITLE'],
          action_hash['input'],
          opt['scenario name'],
          LOCALES_MAPPING[$janus.locale]['COMMON'][LOCALES_MAPPING['eng']['COMMON'].key(opt['button'].capitalize)]
      ).exit_alert if opt['action'].downcase.include? 'rename'
      Common::ModalDialog::ChoiceDialog.new(
          'div.modal-dialog',
          LOCALES_MAPPING[$janus.locale]['SCENARIO_DELETE']['TITLE'],
          LOCALES_MAPPING[$janus.locale]['COMMON'][LOCALES_MAPPING['eng']['COMMON'].key(opt['button'].capitalize)],
          LOCALES_MAPPING[$janus.locale]['SCENARIO_DELETE']['TITLE']
      ).exit_alert if opt['action'].downcase.include? 'delete'

    end

  end
end
