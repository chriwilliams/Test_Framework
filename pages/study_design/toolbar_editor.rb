require_relative 'home'

module StudyDesign
  class ToolbarEditor < Home
    set_url_matcher /.studydesign./


    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      @klass = TOOLBAR_EDITOR
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    elements SELECTOR_MAPPING[TOOLBAR_EDITOR]['Editor']['buttons'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Editor']['buttons'][SELECTOR]
    element SELECTOR_MAPPING[TOOLBAR_EDITOR]['Components']['items'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Components']['items'][SELECTOR]

    element SELECTOR_MAPPING[TOOLBAR_EDITOR]['Bold']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Bold']['button'][SELECTOR]
    element SELECTOR_MAPPING[TOOLBAR_EDITOR]['Italic']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Italic']['button'][SELECTOR]
    element SELECTOR_MAPPING[TOOLBAR_EDITOR]['Numbered List']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Numbered List']['button'][SELECTOR]
    element SELECTOR_MAPPING[TOOLBAR_EDITOR]['Bullet List']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[TOOLBAR_EDITOR]['Bullet List']['button'][SELECTOR]

    # Looks up whether an object is visible or exists at all.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean], true if object is visible otherwise false.
    def has?(name, tag)
      within(SELECTOR_MAPPING[TOOLBAR_EDITOR]['Components']['items'][SELECTOR], visible: true) do
        find(SELECTOR_MAPPING[TOOLBAR_EDITOR][name][tag][SELECTOR], visible: true).visible?
      end
    end


    # Method that finds whether element is [read only] or disabled
    # @param name [String][ELEMENT].to_sym, the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean]
    def readonly?(name, tag)
      within(SELECTOR_MAPPING[TOOLBAR_EDITOR]['Components']['items'][SELECTOR], visible: true) do
        eval(SELECTOR_MAPPING[TOOLBAR_EDITOR][name][tag][ELEMENT]).disabled?
      end
    end

    # Method that finds whether element is [read / write]
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean]
    def read_write?(name, tag)
      !readonly?(name, tag)
    end

    # Clicks on selected object.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    def click(name, tag)
      within(SELECTOR_MAPPING[TOOLBAR_EDITOR]['Components']['items'][SELECTOR], visible: true) do
        find(SELECTOR_MAPPING[TOOLBAR_EDITOR][name][tag][SELECTOR], visible: true).click
      end
    end

  end
end
