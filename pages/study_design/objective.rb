require_relative 'home'
require_relative 'study_design_section'

module StudyDesign
  class ObjectiveAction < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING
    
    element SELECTOR_MAPPING['Objective Action']['Edit']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Objective Action']['Edit']['button'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Objective Action']['Delete']['button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Objective Action']['Delete']['button'][$janus::SELECTOR]

    # Clicks on the Edit button within the dropdown
    # @param action [String], the web element to click on.
    def edit(action = 'Objective Action')
      click_on(SELECTOR_MAPPING[action]['Edit']['button'][$janus::ELEMENT])
    end

    # Clicks on the Delete button within the dropdown
    def delete(action = 'Objective Action')
      click_on(SELECTOR_MAPPING[action]['Delete']['button'][$janus::ELEMENT])
    end

  end

  class Objective < Scenario
    attr_reader :page_container_list

    set_url_matcher /.studydesign./

    def initialize
      @klass = OBJECTIVE
      @description = nil
      @collection = []
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    section SELECTOR_MAPPING[OBJECTIVE]['Action']['section'][ELEMENT].to_sym, ObjectiveAction, SELECTOR_MAPPING[OBJECTIVE]['Action']['dropdown'][SELECTOR]


    element SELECTOR_MAPPING[OBJECTIVE]['Header']['text'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Header']['text'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['label'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['First Endpoint']['container'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['label'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['New Endpoint']['container'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['link'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['link'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['list'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['toggle-button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['toggle-button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Description']['text'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Description']['text'][SELECTOR]

    element SELECTOR_MAPPING[OBJECTIVE]['Action']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Action']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Action']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Action']['dropdown'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Action']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Action']['list'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Edit']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Edit']['button'][SELECTOR]
    element SELECTOR_MAPPING[OBJECTIVE]['Delete']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Delete']['button'][SELECTOR]

    elements SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['items'][ELEMENT].to_sym, SELECTOR_MAPPING[OBJECTIVE]['Endpoints']['items'][SELECTOR]

    # Method to update Description data and includes it to a collection
    # @param data [String] the description
    def add_objective(data)
      (@collection ||= []).push(data)
      @description = data
    end

    # Method to delete Description data and removes it from the collection
    # @param data [String] the description
    def delete_objective(data)
      @description = nil
      @collection.delete_at(@collection.find_index(data))
    end

    # Method that resets description
    # @param data [String], description
    def reset(data)
      if @collection.include? data
        @description = data
      else
        raise "Unable to find Objective Description: #{data} in class #{self.class.to_s}"
      end
    end

    # Looks up whether an object is visible or exists at all.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # Returns true if object is visible otherwise false.
    def has?(name, tag)
      within(@page_container_list, text: @description) do
        element_is_visible(name, tag, OBJECTIVE)
      end
    end

    # Clicks on selected object.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    def click(name, tag)
      within(@page_container_list, text: @description) do
        case name.downcase
          when 'edit', 'delete'
            click_on_button('Action', 'button', OBJECTIVE)
            self.send("wait_until_#{SELECTOR_MAPPING[OBJECTIVE]['Action']['dropdown'][ELEMENT]}_visible")
            self.send("#{SELECTOR_MAPPING[OBJECTIVE]['Action']['section'][ELEMENT]}").send(name.downcase)
          else
            click_on_button(name, tag, OBJECTIVE)
        end
      end
    end

    # Toggle-clicks on selected object.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    def toggle_click_on_button(name, tag, container, state = true)
      within(@page_container_list, text: @description) do
        attr = SELECTOR_MAPPING[OBJECTIVE][name][tag][STATE][state] || (state ? 'fa-caret-down' : 'fa-caret-right')
        click_on_button(name, tag, OBJECTIVE) if (!wait_visibility(name, tag, OBJECTIVE)[:class].include? attr)
      end
    end

  end
end


