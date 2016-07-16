require_relative 'home'

module StudyDesign
  class EndpointForm < ObjectivesEndpoints
    set_url_matcher /.studydesign./

    def initialize
      @klass = ENDPOINT_FORM
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # returns CSS Selector for the Edit Endpoint form
    def edit_form
      SELECTOR_MAPPING[ENDPOINT_FORM]['Edit Container']
    end

    # returns CSS Selector for the Add Endpoint form
    def add_form
      SELECTOR_MAPPING[ENDPOINT_FORM]['Add Container']
    end

    # returns CSS Selector for the iframe container within the Endpoint form
    def iframe
      SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['iframe'][SELECTOR]
    end

    element SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['iframe'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['iframe'][SELECTOR]
    element SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['toolbar'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['toolbar'][SELECTOR]
    element SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['tinymce'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Editor']['tinymce'][SELECTOR]

    element SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Type']['dropdown'][SELECTOR]
    element SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Subtype']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Subtype']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[ENDPOINT_FORM]['Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Save']['button'][SELECTOR]
    element SELECTOR_MAPPING[ENDPOINT_FORM]['Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Save']['button'][SELECTOR]

    element SELECTOR_MAPPING[ENDPOINT_FORM]['Disabled Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Disabled Save']['button'][SELECTOR]

    element SELECTOR_MAPPING[ENDPOINT_FORM]['Cancel']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Cancel']['button'][SELECTOR]
    element SELECTOR_MAPPING[ENDPOINT_FORM]['Cancel']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ENDPOINT_FORM]['Cancel']['button'][SELECTOR]


    # method that creates and endpoint given data
    def add_endpoint(data={})
      create_endpoint(add_form, data)
    end

    # method that updates and endpoint given data
    def edit_endpoint(data={})
      create_endpoint(edit_form, data)
    end

    # method that deletes a given endpoint
    def delete_endpoint
    end

    private

    # private method that creates or update an endpoint given the form container and the data
    def create_endpoint(form, data={})
      within form do
        within iframe do
          within_frame(find(:xpath, '.')){ page.find_by_id('tinymce').native.send_keys data['endpoint description'] } if data.has_key? 'endpoint description'
        end
        eval(SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Type']['dropdown'][ELEMENT]).select(data['endpoint type']) if data.has_key? 'endpoint type'
        eval(SELECTOR_MAPPING[ENDPOINT_FORM]['Endpoint Subtype']['dropdown'][ELEMENT]).select(data['endpoint subtype']) if data.has_key? 'endpoint subtype'
        click_button data['action'].capitalize
      end
      page.assert_no_selector(form)
    end

  end
end
