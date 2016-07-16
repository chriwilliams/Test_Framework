require_relative 'home'

module StudyDesign
  class Schedules < Scenario
    set_url_matcher /.\/schedules*/

    def initialize
      @klass = SCHEDULES
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element :schedules_page_active_schedule_title, SELECTOR_MAPPING[SCHEDULES]['Active Schedule']['title'][SELECTOR]

    element :schedules_page_new_schedule_button, SELECTOR_MAPPING[SCHEDULES]['New Schedule']['button'][SELECTOR]
    element :schedules_page_new_schedule_label, SELECTOR_MAPPING[SCHEDULES]['New Schedule']['label'][SELECTOR]

    element :schedules_page_schedule_selector_button, SELECTOR_MAPPING[SCHEDULES]['Schedule Selector']['button'][SELECTOR]
    element :schedules_page_schedule_selector_label, SELECTOR_MAPPING[SCHEDULES]['Schedule Selector']['label'][SELECTOR]
    element :schedules_page_schedule_selector_dropdown, SELECTOR_MAPPING[SCHEDULES]['Schedule Selector']['dropdown'][SELECTOR]

    # This method will create a new schedule and ensuring the selection title is updated
    def create_new_schedule()
      wait_until_schedules_page_new_schedule_button_visible
      schedules_page_new_schedule_button.click
      self.wait_for_no_spinner
      wait_until_schedules_page_new_schedule_button_visible
      wait_until_schedules_page_active_schedule_title_visible
      self.wait_for_no_spinner
      MIST::AsyncHelper.wait_until{(schedules_page_active_schedule_title.text =~ /Schedule\s*\d+/i) == 0}
    end

    # This method selects a new schedule based on name.
    # Note: If the name is selected it will not attempt to navigate. The assumption made is that each schedule name is unique.
    # @param schedule_name [String] the Schedule name to switch.
    def navigate_to_schedule(schedule_name)
      self.wait_for_no_spinner

      wait_until_schedules_page_active_schedule_title_visible
      unless (schedules_page_active_schedule_title.text == schedule_name)
        schedules_page_schedule_selector_button.click
        wait_until_schedules_page_schedule_selector_dropdown_visible
        schedules_page_schedule_selector_dropdown.all('li a',text: schedule_name).first.click

        self.wait_for_no_spinner
        MIST::AsyncHelper.wait_until{(schedules_page_active_schedule_title.text == schedule_name)}
      end
    end


  end
end
