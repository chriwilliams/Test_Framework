require_relative 'home'

module StudyDesign
  class SchedulesTabs < Scenario
    set_url_matcher /.\/schedules*/

    def initialize
      @klass = SCHEDULES_TABS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[SCHEDULES_TABS]['New Schedule']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['New Schedule']['button'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULES_TABS]['New Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['New Schedule']['label'][SELECTOR]


    element SELECTOR_MAPPING[SCHEDULES_TABS]['Active Schedule']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Active Schedule']['tab'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULES_TABS]['Active Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Active Schedule']['label'][SELECTOR]

    elements SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['tab'][SELECTOR]
    elements SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['label'][SELECTOR]
    elements SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['label'][SELECTOR]

    elements SELECTOR_MAPPING[SCHEDULES_TABS]['Delete Schedule']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULES_TABS]['Delete Schedule']['button'][SELECTOR]

    # Given a scenario name, it seeks to delete the first tab with the name
    # @param name [String], the name of schedule tab
    # Given scenario with name is deleted.
    def delete_tab(name)
      within(SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['tab'][SELECTOR], text:name) do
        find(SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['delete button'][SELECTOR]).click
      end
    end

    # Switches to new tab
    # @param name [String], the name of scenario tab
    def switch_to_tab(name)
      first(SELECTOR_MAPPING[SCHEDULES_TABS]['Schedule']['tab'][SELECTOR], text:name).click
    end

    def contains?(item, tag, value)
      # $async.wait_until { self.send("#{SELECTOR_MAPPING[SCHEDULES_TABS][item][tag][ELEMENT]}").text.include? value }
      SitePrism::Waiter.wait_until_true { self.send("#{SELECTOR_MAPPING[SCHEDULES_TABS][item][tag][ELEMENT]}").text.include? value }
      super
    end
  end
end
