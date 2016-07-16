require_relative 'home'

module StudyDesign
  class ObjectiveForm < ObjectivesEndpoints
    set_url_matcher /.studydesign./

    def initialize
      @klass = OBJECTIVE_FORM
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # Edit Form container
    def edit_form
      SELECTOR_MAPPING[OBJECTIVE_FORM]['Edit Container']
    end

    # Add Form container
    def add_form
      SELECTOR_MAPPING[OBJECTIVE_FORM]['Add Container']
    end

    #iFrame for editing
    def iframe
      SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['iframe'][SELECTOR]
    end

    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['iframe'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['iframe'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['toolbar'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['toolbar'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['tinymce'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Editor']['tinymce'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Objective Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Objective Type']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Save']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Save']['button'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Disabled Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Disabled Save']['button'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Cancel']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Cancel']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE_FORM]['Cancel']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE_FORM]['Cancel']['button'][SELECTOR]


    # Method that creates and objective given data
    # @param data [Hash]
    def add_objective(data={})
      create_objective(add_form, data)
    end

    # Method that updates and objective given data
    # @param data [Hash]
    def edit_objective(data={})
      create_objective(edit_form, data)
    end


    private

    # private method that creates or update an objective given the form container and the data
    # @param form [String], the editable form
    # @param data [Hash] content to fill in
    def create_objective(form, data={})
      objective_type = LOCALES_MAPPING[$janus.locale]['objective_type'][data['objective type'].downcase] if data.has_key? 'objective type'
      within form do
        within iframe do
          within_frame(find(:xpath, '.')){ page.find_by_id('tinymce').native.clear  } if data.has_key? 'objective description'
          within_frame(find(:xpath, '.')){ page.find_by_id('tinymce').native.send_keys data['objective description'] } if data.has_key? 'objective description'
        end
        eval(SELECTOR_MAPPING[OBJECTIVE_FORM]['Objective Type']['dropdown'][ELEMENT]).select(objective_type) if objective_type
        click_button LOCALES_MAPPING[$janus.locale]['COMMON'][LOCALES_MAPPING['eng']['COMMON'].key(data['action'].capitalize)]
      end
      page.assert_no_selector(form)
    end

  end
end
