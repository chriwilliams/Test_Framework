require_relative 'home'

module StudyDesign
  class Activities < ActiveSchedule
    set_url_matcher /.\/activities*/

    def initialize
      @klass = ACTIVITIES
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[ACTIVITIES]['Search']['box'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Search']['box'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITIES]['Search']['input-field'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Search']['input-field'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITIES]['Empty Search']['box'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Empty Search']['box'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITIES]['No Activities']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['No Activities']['container'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITIES]['No Activity Results']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['No Activity Results']['container'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITIES]['Activity Results']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Activity Results']['container'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITIES]['Activity Results']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Activity Results']['table'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITIES]['Added Activities']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Added Activities']['container'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITIES]['Added Activities']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITIES]['Added Activities']['table'][SELECTOR]

  end
end
