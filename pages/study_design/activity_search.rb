require_relative 'home'

module StudyDesign
  class ActivitySearch < Activities
    set_url_matcher /.\/activities*/

    def initialize
      @klass = ACTIVITY_SEARCH
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[ACTIVITY_SEARCH]['Hint']['text'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_SEARCH]['Hint']['text'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITY_SEARCH]['Search']['input-field'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_SEARCH]['Search']['input-field'][SELECTOR]

  end
end
