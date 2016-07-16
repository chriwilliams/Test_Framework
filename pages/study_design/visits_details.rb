require_relative 'home'

module StudyDesign
  class VisitsDetails < Schedules
    set_url_matcher /.\/visits*/

    def initialize
      @klass = VISITS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[VISITS]['Visits']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visits']['panel'][SELECTOR]

    elements SELECTOR_MAPPING[VISITS]['Visit Row']['items'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Row']['items'][SELECTOR]

    element SELECTOR_MAPPING[VISITS]['New Visit']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['New Visit']['button'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Visits Quantity']['input-field'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visits Quantity']['input-field'][SELECTOR]

    element SELECTOR_MAPPING[VISITS]['Encounter Type']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Encounter Type']['header'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Encounter Type']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Encounter Type']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Encounter Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Encounter Type']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[VISITS]['Visit Type']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Type']['header'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Visit Type']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Type']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Visit Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Type']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[VISITS]['Visit Name']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Name']['header'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Visit Name']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Name']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISITS]['Visit Name']['input-field'][ELEMENT].to_sym, SELECTOR_MAPPING[VISITS]['Visit Name']['input-field'][SELECTOR]



    # counts the number of items in collection
    # @option name [String] :optional value for the object name
    # @option tag [String] :optional value for the object tag
    # @return [Integer]
    def count(name=nil, tag=nil)
      sleep 1
      current_visits_count = page.all('tbody.study-events-visits tr').count || 0
      if current_visits_count > 0
        10.times do
          break if page.find('tbody.study-events-visits').has_css?('tr', count: current_visits_count)
          sleep 1
          current_visits_count = page.all('tbody.study-events-visits tr').count
        end
      end
      current_visits_count
    end

    # @param visits [Array[Hash]]
    # @option visit [String] :encounter_type
    # @option visit [String] :visit_type
    # @option visit [String] :name
    def add(visits)
      current_visits_count = self.count
      new_visits_count = visits.size

      self.send("wait_until_#{SELECTOR_MAPPING[VISITS]['Visits Quantity']['input-field'][ELEMENT]}_visible")
      self.send(SELECTOR_MAPPING[VISITS]['Visits Quantity']['input-field'][ELEMENT] .to_sym).set new_visits_count

      self.send("wait_until_#{SELECTOR_MAPPING[VISITS]['New Visit']['button'][ELEMENT]}_visible")
      self.send(SELECTOR_MAPPING[VISITS]['New Visit']['button'][ELEMENT] .to_sym).click

      visits.each_with_index do |visit, index|
        update(index + current_visits_count, visit)
      end
    end

    # @param nth_row [Integer] the visit to update
    # @param fields [Hash] the fields to update
    # @option fields [String] :encounter_type
    # @option fields [String] :visit_type
    # @option fields [String] :name
    def update(nth_row, fields)
      fields.each_pair do |key, value|
        css = case key
                when :encounter_type
                  "td #visit-encounter-type_#{nth_row}.form-control"
                when :visit_type
                  "td #visit-visit-type_#{nth_row}.form-control"
                when :name
                  "td #visit-name_#{nth_row}.form-control"
              end
        msg = nil
        # page.all('#study-events-visits tr')[nth_row].click
        10.times do |i|
          set_value(css, value)
          # sleep 1
          page.all('#study-events-visits tr')[nth_row].click
          sleep 1
          msg = verify_value(css, value)
          break unless msg
          msg = nil
          sleep 1
        end
        raise Capybara::ExpectationNotMet, msg if msg
      end
    end

    private

    def set_value(css, value)
      case css
        when /\-type_/
          page.find(css, visible: true, wait: 10).select value
        else
          element = page.find(css, visible: true, wait:10)
          element.click
          element.set value
      end
    end

    def verify_value(css, value)
      raise Capybara::ExpectationNotMet, "css: #{css}, value: #{value}" unless page.has_css?(css, visible: true, wait: 10)
      $async.wait_with_retries(errors: Exception, timeout: 1) do
        case css
          when /\-type_/
            "expected to select #{css[/visit\-(.+\-type)_\d+/, 1]} of '#{value}'" unless page.all("#{css} option", visible: true, wait: 10).find(&:selected?).text == value
          else
            "expected to set visit name of #{value}" unless page.find(css, visible: true, wait: 10).value == value
        end
      end
    end

  end
end
