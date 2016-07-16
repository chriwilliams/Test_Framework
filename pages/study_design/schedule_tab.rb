require_relative 'home'

module StudyDesign
  class ScheduleTab < SchedulesTabs
    set_url_matcher /.\/schedules*/

    def initialize
      @klass = SCHEDULE_TAB
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end


    # capture Selectors
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['tab'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['label'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['panel'][SELECTOR]

    element SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['tab'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['label'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['panel'][SELECTOR]

    element SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['tab'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['label'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['panel'][SELECTOR]

    def switch_to(tab)
      case tab
        when /^activit(?:y|ies)$/i
          self.click('Activities', 'tab') unless self.send("#{SELECTOR_MAPPING[SCHEDULE_TAB]['Activities']['tab'][ELEMENT]}")[:class] .include? 'selected'
        when /^visits?$/i
          self.click('Visits', 'tab') unless self.send("#{SELECTOR_MAPPING[SCHEDULE_TAB]['Visits']['tab'][ELEMENT]}")[:class] .include? 'selected'
        when /^schedule grid$/i
          self.click('Schedule Grid', 'tab') unless self.send("#{SELECTOR_MAPPING[SCHEDULE_TAB]['Schedule Grid']['tab'][ELEMENT]}")[:class] .include? 'selected'
      end
      sleep 0.5
    end

  end
end
