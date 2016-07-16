require_relative 'home'

module StudyDesign
  class NoObjectives < Scenario
    set_url_matcher /.studydesign./

    def initialize
      @klass = NO_OBJECTIVES
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[NO_OBJECTIVES]['Add Objective']['link'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_OBJECTIVES]['Add Objective']['link'][SELECTOR]
    element SELECTOR_MAPPING[NO_OBJECTIVES]['Add Objective']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_OBJECTIVES]['Add Objective']['label'][SELECTOR]

  end
end

