require_relative 'home'

module StudyDesign
  class NoSchedule < Scenario
    set_url_matcher /.\/no-schedules*/

    def initialize
      @klass = NO_SCHEDULE
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element :no_schedule_page_container_panel, SELECTOR_MAPPING[NO_SCHEDULE]['Container']['panel'][SELECTOR]
    element :no_schedule_page_new_schedule_label, SELECTOR_MAPPING[NO_SCHEDULE]['New Schedule']['label'][SELECTOR]
    element :no_schedule_page_new_schedule_button, SELECTOR_MAPPING[NO_SCHEDULE]['New Schedule']['button'][SELECTOR]

    def create_new_schedule()
      wait_until_no_schedule_page_container_panel_visible
      wait_until_no_schedule_page_new_schedule_button_visible
      no_schedule_page_new_schedule_button.click
      self.wait_for_no_spinner
    end
  end
end
