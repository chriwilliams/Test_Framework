require_relative 'home'

module StudyDesign
  class EditableEndpoint < ObjectivesEndpoints
    set_url_matcher /.studydesign./

    def initialize
      @klass = EDITABLE_ENDPOINT
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Add Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Add Endpoint']['container'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Add Endpoint']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Add Endpoint']['header'][SELECTOR]

    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Edit Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Edit Endpoint']['container'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Edit Endpoint']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['Edit Endpoint']['header'][SELECTOR]

    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['First Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['First Endpoint']['container'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['First Endpoint']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['First Endpoint']['header'][SELECTOR]

    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['New Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['New Endpoint']['container'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_ENDPOINT]['New Endpoint']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_ENDPOINT]['New Endpoint']['header'][SELECTOR]

  end
end
