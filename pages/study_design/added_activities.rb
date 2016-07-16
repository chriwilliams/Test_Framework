require_relative 'home'

module StudyDesign
  class AddedActivities < Activities
    set_url_matcher /.\/activities*/

    def initialize
      @klass = ADDED_ACTIVITIES
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element SELECTOR_MAPPING[ADDED_ACTIVITIES]['Activity Name']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Activity Name']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ADDED_ACTIVITIES]['Activity Name']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Activity Name']['column'][SELECTOR]

    element SELECTOR_MAPPING[ADDED_ACTIVITIES]['Code']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Code']['header'][SELECTOR]
    elements SELECTOR_MAPPING[ADDED_ACTIVITIES]['Code']['column'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Code']['column'][SELECTOR]


    elements SELECTOR_MAPPING[ADDED_ACTIVITIES]['Delete Activity']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Delete Activity']['button'][SELECTOR]
    elements SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][ELEMENT].to_sym, SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][SELECTOR]


    # method that verifies an activity exists
    # @param options [Hash]
    def has_activity_content?(options={})
      items = all(SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][SELECTOR], text: options['activity name'])
      codes = items.select{|code| code.text.include? options['code']}
      codes.count == options['count'].to_i
    end

    # method that counts the number of activity rows with a specific matching text
    # @param options [Hash]
    def count_activity(content)
      all(SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][SELECTOR], text: content).count
    end

    # method that delete an activity by clicking on the delete button
    # @param content [String]
    # @param index [Integer], optioanl integer value
    def delete_activity(content, index = nil)
      if index
        item = all(SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][SELECTOR], text: content)[index]
      else
        item = first(SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['items'][SELECTOR], text: content)
      end
      item.find(SELECTOR_MAPPING[ADDED_ACTIVITIES]['Row Activity']['Delete Button']).click
    end

  end
end
