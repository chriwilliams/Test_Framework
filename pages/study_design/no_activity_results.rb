module StudyDesign
  class NoActivityResults < Activities
    set_url_matcher /.\/activities*/

    def initialize
      @klass = NO_ACTIVITIES_RESULTS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[NO_ACTIVITIES_RESULTS]['Message']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_ACTIVITIES_RESULTS]['Message']['label'][SELECTOR]
    element SELECTOR_MAPPING[NO_ACTIVITIES_RESULTS]['Close']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_ACTIVITIES_RESULTS]['close']['button'][SELECTOR]

  end
end
