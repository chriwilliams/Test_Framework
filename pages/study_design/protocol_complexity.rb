require_relative 'home'

module StudyDesign
  class ProtocolComplexity < Analytics
    set_url_matcher /.\/analytics*/

    def initialize
      @klass = PROTOCOL_COMPLEXITY
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Chart']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Chart']['title'][SELECTOR]
    element SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Chart']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Chart']['container'][SELECTOR]
    element SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Specificity']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[PROTOCOL_COMPLEXITY]['Specificity']['title'][SELECTOR]

  end
end



