require_relative 'home'

module StudyDesign
  class NoScenario < Home
    set_url_matcher /.no-scenarios.*/

    def initialize
      @klass = NO_SCENARIO
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # capture Selectors
    element :welcome_message_label, SELECTOR_MAPPING[NO_SCENARIO]['Welcome Message']['label'][SELECTOR]
    element :start_design_button_label, SELECTOR_MAPPING[NO_SCENARIO]['Start Design']['label'][SELECTOR]
    element :start_design_button, SELECTOR_MAPPING[NO_SCENARIO]['Start Design']['button'][SELECTOR]

    element :read_only_container, SELECTOR_MAPPING[NO_SCENARIO]['Read Only']['container'][READ_ONLY]
    element :read_only_label, SELECTOR_MAPPING[NO_SCENARIO]['Read Only']['label'][READ_ONLY]

    # method that returns the welcome message is present on the page.
    def welcomeMessage
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { welcome_message_label.visible? }
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { !welcome_message_label.text.empty? }
      welcome_message_label.text
    end

    # Returns Boolean whether the page has read only information
    # @param text [String] optional parameter to verify statement on page
    # #return [Boolean] stating whether page can be accessed
    #
    def verifyPageIsReadOnly(text = nil)
      if self
        self.wait_until_read_only_container_visible
        self.wait_until_read_only_label_visible

        retun read_only_label.text == text if text
      else
        return false
      end

    end

    # method that returns the start design button and label is present on the page.
    def startDesignButtonLabel
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { start_design_button_label.visible? }
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { !start_design_button_label.text.empty? }
      start_design_button_label.text
    end

  end
end
