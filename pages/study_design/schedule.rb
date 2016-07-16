require_relative 'home'

module StudyDesign
  class Schedule < Scenario
    set_url_matcher /.\/schedules*/

    def initialize
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element :new_schedule_button, SELECTOR_MAPPING[SCHEDULE]['New Schedule']['button'][SELECTOR]

    def has?(name, tag)
      element_is_visible(name, tag, SCHEDULE)
    end

    def click(name, tag)
      click_on_button(name, tag, SCHEDULE)
    end
  end
end
