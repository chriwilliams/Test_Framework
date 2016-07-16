require_relative '../common/base_page'
require_relative 'selector_helper'
require_relative 'home'

module StudyDesign
  class Scenario < Home
    set_url_matcher /.\/scenarios*/

    def initialize
      @klass = SCENARIO
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # Scenario page
    element SELECTOR_MAPPING[SCENARIO]['Scenario Tab']['bar'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Scenario Tab']['bar'][SELECTOR]

    element :scenario_page_analytics_button, SELECTOR_MAPPING[SCENARIO]['Analytics']['button'][SELECTOR]
    element :scenario_page_analytics_label, SELECTOR_MAPPING[SCENARIO]['Analytics']['label'][SELECTOR]
    element :scenario_page_analytics_panel, SELECTOR_MAPPING[SCENARIO]['Analytics']['panel'][SELECTOR]

    element :scenario_page_benchmark_analysis_button, SELECTOR_MAPPING[SCENARIO]['Benchmark Analysis']['button'][SELECTOR]
    element :scenario_page_benchmark_analysis_label, SELECTOR_MAPPING[SCENARIO]['Benchmark Analysis']['label'][SELECTOR]
    element :scenario_page_benchmark_analysis_panel, SELECTOR_MAPPING[SCENARIO]['Benchmark Analysis']['panel'][SELECTOR]

    element :scenario_page_schedule_button, SELECTOR_MAPPING[SCENARIO]['Schedule']['button'][SELECTOR]
    element :scenario_page_schedule_label, SELECTOR_MAPPING[SCENARIO]['Schedule']['label'][SELECTOR]
    element :scenario_page_schedule_panel, SELECTOR_MAPPING[SCENARIO]['Schedule']['panel'][SELECTOR]

    element SELECTOR_MAPPING[SCENARIO]['No Schedule']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['No Schedule']['container'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Schedules']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Schedules']['container'][SELECTOR]

    element SELECTOR_MAPPING[SCENARIO]['Study Identification']['link'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Study Identification']['link'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Study Identification']['name'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Study Identification']['name'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Study Identification']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Study Identification']['panel'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Study Identification']['toggle-button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Study Identification']['toggle-button'][SELECTOR]

    element SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['link'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['link'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['name'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['name'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['panel'][SELECTOR]
    element SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['toggle-button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['Objectives/Endpoints']['toggle-button'][SELECTOR]

    element SELECTOR_MAPPING[SCENARIO]['No Objectives']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[SCENARIO]['No Objectives']['container'][SELECTOR]


    # Protected Method that handles a toggle-click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def toggle_click(name, tag, state = true)
      super unless tag == 'button'
      attr = 'active'
      case name
        when /^schedule$/i
          self.wait_until_scenario_page_schedule_button_visible
          scenario_page_schedule_button.click if (state ^ (scenario_page_schedule_button[:class].include? attr))
        when /^benchmark analysis$/i
          self.wait_until_scenario_page_benchmark_analysis_button_visible
          scenario_page_benchmark_analysis_button.click if (state ^ (scenario_page_benchmark_analysis_button[:class].include? attr))
        when /^analytics$/i
          self.wait_until_scenario_page_analytics_button_visible
          scenario_page_analytics_button.click if (state ^ (scenario_page_analytics_button[:class].include? attr))
        else
          super
      end
      self.wait_for_no_spinner
    end
  end
end
