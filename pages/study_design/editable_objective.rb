module StudyDesign
  class EditableObjective < ObjectivesEndpoints
    set_url_matcher /.studydesign./

    def initialize
      @klass = EDITABLE_OBJECTIVE
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Add Objective']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Add Objective']['form'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Add Objective']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Add Objective']['header'][SELECTOR]

    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Edit Objective']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Edit Objective']['form'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Edit Objective']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['Edit Objective']['header'][SELECTOR]

    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['First Objective']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['First Objective']['header'][SELECTOR]
    element SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['New Objective']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[EDITABLE_OBJECTIVE]['New Objective']['header'][SELECTOR]

    def contains?(item, tag, text)
      text = update_text(text)
      super
    end

    def matches?(item, tag, text)
      text = update_text(text)
      super
    end

    private

    def update_text(text)
      if text.include? '- All fields are required'
        required = LOCALES_MAPPING[$janus.locale]['COMMON']['ALL_FIELDS_REQUIRED']
        case text.split('-')[0].strip
          when /^add objective$/i
            text = [LOCALES_MAPPING[$janus.locale]['SCENARIO_DETAILS']['OBJECTIVES']['ADD_OBJECTIVE'], required].join(' ')
          when /^edit objective$/i
            text = [LOCALES_MAPPING[$janus.locale]['SCENARIO_DETAILS']['OBJECTIVES']['EDIT_OBJECTIVE'], required].join(' ')
        end
      end
      return text
    end

  end
end
