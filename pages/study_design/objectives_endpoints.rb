module StudyDesign
  class ObjectivesEndpoints < Scenario
    set_url_matcher /.studydesign./

    def initialize
      @klass = OBJECTIVES_ENDPOINTS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['container'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['first container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['first container'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['new container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Editable Objective']['new container'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Active Objective']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Active Objective']['container'][SELECTOR]


    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['New Objective']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['New Objective']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['New Objective']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['New Objective']['label'][SELECTOR]

    elements SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Objectives']['headers'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Objectives']['headers'][SELECTOR]
    elements SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Objectives']['text'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Objectives']['text'][SELECTOR]

    elements SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Endpoints']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVES_ENDPOINTS]['Endpoints']['list'][SELECTOR]


    # Method that counts number of objectives or endpoints
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # Returns the actual count
    def count(item, tag)
      items = item.downcase.split
      type = items[0]
      subtype = items[1]
      case type
        when 'objective' then count_objectives(item, tag, subtype)
        when 'endpoint' then count_endpoints(subtype)
      end
    end

    def includes?(name, tag, value)
      sleep 3 #TODO removal of sleeper
      get_collection(name, tag, OBJECTIVES_ENDPOINTS).map { |content| content.text }.include? value
    end

  end
end
