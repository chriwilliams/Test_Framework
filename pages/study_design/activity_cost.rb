require_relative 'home'

module StudyDesign
  class ActivityCost < Analytics
    set_url_matcher /.\/analytics*/

    def initialize
      @klass = ACTIVITY_COST
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[ACTIVITY_COST]['Chart']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_COST]['Chart']['title'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITY_COST]['Chart']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_COST]['Chart']['container'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITY_COST]['View Chart Details']['link'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_COST]['View Chart Details']['link'][SELECTOR]
  end
end



