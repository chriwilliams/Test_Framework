require_relative 'home'
require_relative '../common/base_modal_dialogs'
require_relative 'study_design_section'

module StudyDesign
  class ScheduleAction < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Schedule Action']['Rename']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Schedule Action']['Rename']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Schedule Action']['Delete']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Schedule Action']['Delete']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Schedule Action']['Copy']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Schedule Action']['Copy']['button'][$janus::SELECTOR]

  end
  class ActiveSchedule < SchedulesTabs
    set_url_matcher /.\/schedules*/

    def initialize
      @klass = ACTIVE_SCHEDULE
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The active scenario was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Schedule Tab']['bar'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Schedule Tab']['bar'][SELECTOR]

    section SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['section'][ELEMENT].to_sym, ScheduleAction, SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['section'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['button'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['dropdown'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['list'][SELECTOR]

    # Method: invoke_action, invokes various actions provided though hash methods
    # @param: opt [Hash] takes 0 or more parameters.
    def invoke_action(opt = {})
      action_hash = SELECTOR_MAPPING[ACTIVE_SCHEDULE][opt['action'].capitalize.gsub(/(Rename|Delete|Copy).*$/,'\1')] || {}
      click_on_button('Action', 'button', ACTIVE_SCHEDULE)
      self.send("wait_until_#{SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['dropdown'][ELEMENT]}_visible")

      self.send("#{SELECTOR_MAPPING[ACTIVE_SCHEDULE]['Action']['section'][ELEMENT]}").invoke_click(opt['action'].downcase.gsub(/(rename|delete|copy).*$/,'\1'), 'Schedule Action')

      Common::ModalDialog::InputDialog.new('div.modal-dialog', action_hash['title'], action_hash['input'], opt['schedule name'], opt['button']).exit_alert if opt['action'].downcase.include? 'rename'
      Common::ModalDialog::ChoiceDialog.new('div.modal-dialog', action_hash['title'], opt['button'], action_hash['description']).exit_alert if opt['is linked']
    end

  end
end
