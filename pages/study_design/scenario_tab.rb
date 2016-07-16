require_relative 'home'

module StudyDesign
  class ScenarioTab < Scenario
    set_url_matcher /.\/scenarios*/

    def initialize
      @klass = SCENARIO_TAB
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[SCENARIO_TAB]['New Scenario']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['New Scenario']['button'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO_TAB]['New Scenario']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['New Scenario']['label'][SELECTOR]

    elements SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['tab'][SELECTOR]
    elements SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['label'][SELECTOR]
    elements SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['delete button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['delete button'][SELECTOR]

    element SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['tab'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['tab'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['label'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['delete button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['delete button'][SELECTOR]


    # Looks up whether an object is visible or exists at all.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # Returns true if object is visible otherwise false.
    def has?(name, tag)
      # cannot check visibility on a collections of tabs, so checking the tab bar itself
      tag = 'bar' if tag == 'tabs'
      element_is_visible(name, tag, @klass)
    end

    # TODO: Method has been obsoleted due to feature & layout changes
    # Given a scenario name, it seeks to delete the first tab with the name
    # @param name [String], the name of scenario tab
    # Given scenario with name is deleted.
    def delete_tab(name)
      within(SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['tab'][SELECTOR], text:name) do
        find(SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['delete button'][SELECTOR]).click
      end
    end

    # Switches to new tab
    # @param name [String], the name of scenario tab
    def switch_to_tab(name)
      tab = first(SELECTOR_MAPPING[SCENARIO_TAB]['Scenario']['tab'][SELECTOR], text: name)

      unless (tab['class'].include? 'active')
        tab.click
        sleep_until(20,5) { (find(SELECTOR_MAPPING[SCENARIO_TAB]['Active Scenario']['label'][SELECTOR], text: name)) }
      end
    end

  end
end
