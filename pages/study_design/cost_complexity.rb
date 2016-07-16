module StudyDesign
  class CostComplexity < Analytics
    set_url_matcher /.\/analytics*/

    def initialize
      @klass = COST_COMPLEXITY
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[COST_COMPLEXITY]['Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Schedule']['label'][SELECTOR]
    element SELECTOR_MAPPING[COST_COMPLEXITY]['Panel']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Panel']['title'][SELECTOR]

    element SELECTOR_MAPPING[COST_COMPLEXITY]['Cost per Subject']['value'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Cost per Subject']['value'][SELECTOR]
    element SELECTOR_MAPPING[COST_COMPLEXITY]['Cost per Subject']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Cost per Subject']['title'][SELECTOR]

    element SELECTOR_MAPPING[COST_COMPLEXITY]['Complexity per Subject']['value'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Complexity per Subject']['value'][SELECTOR]
    element SELECTOR_MAPPING[COST_COMPLEXITY]['Complexity per Subject']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[COST_COMPLEXITY]['Complexity per Subject']['title'][SELECTOR]

  end
end
