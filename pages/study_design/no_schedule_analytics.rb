require_relative 'home'

module StudyDesign
  class NoScheduleAnalytics < Scenario
    set_url_matcher /.\/analytics*/

    def initialize
      @klass = NO_SCHEDULE_ANALYTICS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['panel'][SELECTOR]
    element SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['title'][SELECTOR]
    element SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['description'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_ANALYTICS]['Container']['description'][SELECTOR]

  end
end
