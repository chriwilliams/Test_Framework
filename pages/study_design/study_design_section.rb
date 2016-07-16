require_relative '../common/base_section'
require_relative 'selector_helper'
require_relative '../../lib/helpers/async_helper'
require_relative '../../lib/helpers/faker_helper'

module StudyDesign
  class StudyDesignSection < Common::BaseSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING
    LOCALES_MAPPING = $janus::LOCALES_MAPPING

    # Method performs a specific click action
    # @param action [string], the action to perform e.g. copy, delete, rename
    # @param klass [string], the class name that performs the action
    # tag [string], the actual object tag
    def invoke_click(action, klass, tag = 'button')
      click_on(SELECTOR_MAPPING[klass][action.capitalize][tag][$janus::ELEMENT])
    end

    # Method that selects from a dropdown
    # @param action [string], the action to perform e.g. copy, delete, rename
    # @param klass [string], the class name that performs the action
    # tag [string], the actual object tag
    def invoke_select(action, klass, value, tag = 'select')
      send(SELECTOR_MAPPING[klass][action.capitalize][tag][$janus::ELEMENT]).select value
    end

    protected

    # Clicks on an element within the section, it ensure that the element exists first
    # @param element [String], the web element to click on.
    def click_on(element)
      send("wait_for_#{element}")
      eval(element).click
    end
  end
end
