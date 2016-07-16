require_relative 'home'

module StudyDesign
  class ActivityResults < Activities
    set_url_matcher /.\/activities*/

    def initialize
      @klass = ACTIVITY_RESULTS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Name & Description']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Name & Description']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ACTIVITY_RESULTS]['Name & Description']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Name & Description']['column'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Code']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Code']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ACTIVITY_RESULTS]['Code']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Code']['column'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Protocol Usage %']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Protocol Usage %']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ACTIVITY_RESULTS]['Protocol Usage %']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Protocol Usage %']['column'][SELECTOR]

    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['column'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['check'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['check'][SELECTOR]
    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['count'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Indicator']['count'][SELECTOR]


    element SELECTOR_MAPPING[ACTIVITY_RESULTS]['Close']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Close']['button'][SELECTOR]
    elements SELECTOR_MAPPING[ACTIVITY_RESULTS]['Row Activity']['items'][ELEMENT].to_sym, SELECTOR_MAPPING[ACTIVITY_RESULTS]['Row Activity']['items'][SELECTOR]



    # Method that clicks on an activity row item
    # @param options [HASH], contains required parameters.
    def click_on_activity?(options, count = 1)
      result = true
      (send SELECTOR_MAPPING[ACTIVITY_RESULTS]['Row Activity']['items'][ELEMENT] .to_sym)
               .to_a
               .keep_if { |row| options.collect { |key, value| value }.all? { |item| row.text.include? item } }
               .slice(0, 1)
               .cycle(count) { |elm| elm.click }
      return result
    end

    # Method that verifies an activity exists
    # Clicks on selected object.
    # @param options [HASH], contains required parameters.
    def has_activity_content?(options={})
      !((send SELECTOR_MAPPING[ACTIVITY_RESULTS]['Row Activity']['items'][ELEMENT] .to_sym)
           .to_a
           .keep_if { |row| options.collect { |key, value| value }.all? { |item| row.text.include? item } }
          .empty?)
    end

  end
end
