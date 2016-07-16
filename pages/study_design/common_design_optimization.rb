require_relative '../common/base_page'
require_relative 'selector_helper'
require_relative '../../lib/helpers/async_helper'
require_relative '../../lib/helpers/faker_helper'

module StudyDesign
  class CommonDesignOptimization < Common::BasePage
    attr_reader :klass
    attr_accessor :description

    begin
      $async = MIST::AsyncHelper
      $janus = MIST::Janus::SelectorHelper
      $janusFaker = MIST::FakerHelper
      SELECTOR_MAPPING = $janus::SELECTOR_MAPPING
      LOCALES_MAPPING = $janus::LOCALES_MAPPING
      SELECTOR = $janus::SELECTOR
      READ_ONLY =$janus::READ_ONLY
      TEXTCONTENT = $janus::TEXTCONTENT
      ELEMENT = $janus::ELEMENT
      LABEL = $janus::LABEL
      PANEL = $janus::PANEL
      INPUT_FIELD = $janus::INPUT_FIELD
      STATE = $janus::STATE

      NO_SCENARIO = 'No Scenario'
      SCENARIO = 'Scenario'

      STUDY_IDENTIFICATION = 'Study Identification'

      OBJECTIVES_ENDPOINTS = 'Objectives/Endpoints'
      EDITABLE_OBJECTIVE = 'Editable Objective'
      EDITABLE_ENDPOINT = 'Editable Endpoint'
      OBJECTIVES = 'Objectives'
      OBJECTIVE = 'Objective'
      OBJECTIVE_FORM = 'Objective Form'
      ENDPOINT_FORM = 'Endpoint Form'
      NO_OBJECTIVES = 'No Objectives'
      ENDPOINTS = 'Endpoints'
      ENDPOINT = 'Endpoint'
      ADD_OBJECTIVE = 'Add Objective'
      TOOLBAR_EDITOR = 'Toolbar Editor'

      SCENARIO_TAB = "Scenario Tab"
      ANALYTICS = "Analytics"
      NO_SCHEDULE_ANALYTICS = 'No Schedule Analytics'
      COST_COMPLEXITY = 'Cost Complexity'
      ACTIVITY_COST = 'Activity Cost'
      PROTOCOL_COMPLEXITY = 'Protocol Complexity'
      ANALYTICS_DETAILS = 'Analytics Chart Details'
      ACTIVE_SCENARIO = 'Active Scenario'
      ACTIVE_SCHEDULE = 'Active Schedule'
      SCHEDULE = 'Schedule'
      SCHEDULE_TAB = 'Schedule Tab'
      NO_SCHEDULE = 'No Schedule'
      SCHEDULES = 'Schedules'
      SCHEDULES_TABS = 'Schedules Tabs'
      SCENARIO_NOTE = 'Scenario Note'
      VISITS = 'Visits Details'
      VISIT_ROW ='Visit Row'
      ACTIVITIES = 'Activities'
      ADDED_ACTIVITIES = 'Added Activities'
      ACTIVITY_SEARCH = 'Activity Search'
      ACTIVITY_RESULTS = 'Activity Results'
      NO_ACTIVITIES = 'No Activities'
      NO_ACTIVITY_RESULTS = 'No Activity Results'
      SCHEDULE_GRID = 'Schedule Grid Details'

      CELL_MODAL_DIALOG = 'Cell Modal Dialog'

      BENCHMARK_ANALYSIS = 'Benchmark Analysis'
      NO_SCHEDULE_BENCHMARK_ANALYSIS = 'No Schedule Benchmark Analysis'

      ALL_STUDIES = 'All Studies'

    end


    # Looks up whether an object is visible or exists at all.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # Returns true if object is visible otherwise false.
    def has?(name, tag)
      element_is_visible(name, tag, @klass)
    end

    # Looks up whether an object is not visible or does not exist at all.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # Returns true if object is visible otherwise false.
    def has_no?(name, tag)
      element_is_visible(name, tag, @klass, false)
    end

    # Clicks on selected object.
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    def click(name, tag)
      click_on_button(name, tag, @klass)
    end

    # Method that clicks a toggle-click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param state [Boolean], where each clicks alternate the state
    def toggle_click(name, tag, state = true)
      toggle_click_on_button(name, tag, @klass, state)
    end

    # Method that finds whether string is included
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @param value [String], the value of the string to find.
    # Returns true if value is included otherwise false
    def contains?(name, tag, value)
      get_text_content(name, tag, @klass) =~ /#{value}/ ? true : false
    end

    # Method that finds whether string is included
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @param value [String], the value of the string to find.
    # Returns true if value has matched otherwise false
    def matches?(name, tag, value)
      get_text_content(name, tag, @klass) == value
    end

    # Method that finds whether string is included
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @param value [String], the value of the string to find.
    # Returns true whether string is empty otherwise false
    def empty?(name, tag)
      get_text_content(name, tag, @klass) == ""
    end

    # Method that inserts new value into input-field
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @param value [String]
    def insert(name, tag, value)
      set_text_content(name, tag, @klass, value)
    end

    # Method that sets the value of an object
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item
    def set(name, value)
      set_text_content(name, 'input-field', @klass, value)
    end

    # Method that returns the actual text content
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item
    def get(name,tag)
      get_text_content(name, tag, @klass)
    end

    # Method tha counts the number of items
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item
    def count(name, tag)
      get_items_count(name, tag, @klass)
    end

    # returns true is array is sorted according to order
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item
    # @param order [String]
    def is_sorted(name, tag, order = 'ascending')
      is_array_sorted(name, tag, @klass, order)
    end


    # Given a scenario name, it seeks to delete the first tab with the name
    # @param name [String], the name of scenario tab
    # Given scenario with name is deleted.
    def delete_tab(name)
      raise("Method not implemented for this class: #{@klass}")
    end

    # Switches to new tab
    # @param name [String], the name of scenario tab
    def switch_to_tab(name)
      raise("Method not implemented for this class: #{@klass}")
    end

    # Method: invoke_action, invokes various actions provided though hash methods
    # @param: opt [Hash] takes 0 or more parameters.
    def invoke_action(opt = {})
      raise("Method not implemented for this class: #{@klass}")
    end

    def is_active?(name, tag)
      wait_visibility(name, tag, @klass)[:class] .include? 'active'
    end

    # Method that finds whether element is [read only] or disabled
    # @param name [String][ELEMENT].to_sym, the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean]
    def readonly?(name, tag)
      raise("Method not implemented for this class: #{@klass}")
    end

    # Method that finds whether element is [read / write]
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean]
    def read_write?(name, tag)
      raise("Method not implemented for this class: #{@klass}")
    end

    def switch_locale(locale)
      $janus.locale(locale)
    end

    def scroll_down_container(name, tag)
      selector = SELECTOR_MAPPING[@klass][name][tag][SELECTOR]
      self.send("#{SELECTOR_MAPPING[@klass][name][tag][ELEMENT]}").execute_script("$('html, body').animate({ scrollTop: $('#{selector}').offset().top }, 'slow');")
    end

    protected

    ## Common Methods

    # Protected Method that handles a click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def click_on_button(name, tag, container)
      button = wait_visibility(name, tag, container)
      $async.wait_until { !button.disabled? }
      raise %Q{#{name} #{tag} in #{container} is disabled} if button.disabled?
      button.click
    end

    # Protected Method that determines whether an element is visible
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    # @param yes [Boolean], optional parameter to check visibility
    def element_is_visible(name, tag, container, yes = true)
      elem = wait_visibility(name, tag, container, yes)
      elem ? true : false
    end

    # Protected Method that handles a click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    # @param content [String]
    # @param match [Boolean]
    # @paran klass [String], optional parameter
    def click_on_item(name, tag, container, content, match = true, klass = nil)
      map = SELECTOR_MAPPING[container][name][tag][ELEMENT]
      elem = eval(map)

      res = elem.find {|item| (match ? (item.text == content):((item.text).include? content))}

      res.click
      unless klass.nil?
        SitePrism::Waiter.wait_until_true {res[:class].include? klass}
      end
      sleep 1
    end

    # Protected Method that get a content from object
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_text_content(name, tag, container)
      elem = wait_visibility(name, tag, container)

      case tag
        when 'inputfield', 'input-field', 'field'
          elem.value
        else
          elem.text
      end
    end

    # Protected Method that select items from dropdown
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def select_from_dropdown(name, tag, container, value, dropdown = 'dropdown')
      selection = SELECTOR_MAPPING[container][name][tag][dropdown]

      elem = wait_visibility(name, tag, container)
      elem.select(value, :from => selection)
    end

    # Protected Method that handles a click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def set_text_content(name, tag, container, value)
      wait_visibility(name, tag, container).set(value)
    end

    # Protected Method that sets text value from container
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_items_count(name, tag, container)
      eval(SELECTOR_MAPPING[container][name][tag][ELEMENT]).count.to_i
    end

    # Protected Method that returns list from container
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_list_content(name, tag, container)
      eval(SELECTOR_MAPPING[container][name][tag][ELEMENT])
    end

    # Protected Method that handles a click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_list_text_content(name, tag, container)
      eval(SELECTOR_MAPPING[container][name][tag][ELEMENT]).map{|elem| elem.text}
    end

    # Protected Method that returns the item selected
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_select_options(name, tag, container)
      eval(SELECTOR_MAPPING[container][name][tag]['options'][ELEMENT]).map{ |elem| elem.text }
    end

    # Protected Method that handles a select mathod
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    # @param option [String]
    def set_select_option(name, tag, container, option)
      eval(SELECTOR_MAPPING[container][name][tag]['options'][ELEMENT]).detect{ |elem| elem.text == option }.select_option
    end

    # Protected Method that handles a toggle-click process
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def toggle_click_on_button(name, tag, container, state = true)
      attr = SELECTOR_MAPPING[container][name][tag][STATE][state] || (state ? 'fa-caret-down' : 'fa-caret-right')
      click_on_button(name, tag, container) if (!wait_visibility(name, tag, container)[:class].include? attr)
    end

    # Protected Method that returns the state of a toggle state
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_element_state(name, tag, container)
      elem = wait_visibility(name, tag, container)
      {readonly: elem.disabled?, read_write: !elem.disabled?, empty: ( get_text_content(name, tage, container) == '' ) }
    end

    # Protected Method that returns a collection
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    def get_collection(name, tag, container)
      elem = eval(SELECTOR_MAPPING[container][name][tag][ELEMENT])
    end

    # a generic that shows whether a list is sorted. Using generic sort method that includes empty cell.
    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    # @param order [String], by default 'Ascending'. Other option is 'Descending'
    def is_array_sorted(name, tag, container, order)
      array = eval(SELECTOR_MAPPING[container][name][tag][ELEMENT]).map{|e| e.text.to_f}

      sorted = array.sort { |x,y| y <=> x }
      sorted.reverse! if order=='ascending'

      array == sorted
    end

    # A method that takes a string with a specific index call and returns a hash with name and index
    # @example occurrence("visit 4 [>3]") returns {"name"=>"visit 4", "index"=>3}
    # @param item [String], string item to parse
    # @return [Hash], a Hash with @param name[String], and @param index[Integer]
    def occurrence(item)
      {'name' => item[/^(.+) \>\[\d+\]$/, 1] || item, 'index' => (item[/^.+ \>\[(\d+)\]$/, 1] || 1).to_i - 1}
    end

    private

    # @param name [String], name of the item to look for
    # @param tag [String], tag or title of the item
    # @param container [String]
    # @return true if object exists, otherwise false. It will wait until object is accessible by view
    def wait_visibility(name, tag, container, yes = true)
      begin
        elem = eval(SELECTOR_MAPPING[container][name][tag][ELEMENT])
      rescue
        elem = nil
      else
        SitePrism::Waiter.wait_until_true {yes ? (elem.visible?) : !(elem || elem.visible?)}
        return elem
      end
    rescue => e
      nil
    end


    # An Experiment method
    # TODO Allow method to return object
    def sleep_until(time, pulse = 1)
      time.times do
        break if block_given? && yield
        sleep(pulse)
      end
    end
  end
end
