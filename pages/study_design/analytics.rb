require_relative 'home'
require_relative 'study_design_section'

module StudyDesign

  class AnalyticsScheduleNavigation < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Schedule Selection']['Navigate']['select'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Schedule Selection']['Navigate']['select'][$janus::SELECTOR]

  end

  class CostComplexitySection< StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Cost & Complexity Section']['Clinical Activity']['title'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Clinical Activity']['title'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Minimum Clinical Activity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Minimum Clinical Activity']['value'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Maximum Clinical Activity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Maximum Clinical Activity']['value'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Expected Clinical Activity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Expected Clinical Activity']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['Cost & Complexity Section']['Protocol Complexity']['title'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Protocol Complexity']['title'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Minimum Protocol Complexity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Minimum Protocol Complexity']['value'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Maximum Protocol Complexity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Maximum Protocol Complexity']['value'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cost & Complexity Section']['Expected Protocol Complexity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cost & Complexity Section']['Expected Protocol Complexity']['value'][$janus::SELECTOR]

    def verify_content(contents={})
      contents.each do |key, value|
        raise StandardError, "Unable to find value: \"#{value}\" under Cost & Complexity panel for \"#{key}\"" unless self.send(SELECTOR_MAPPING['Cost & Complexity Section'][key]['value'][$janus::ELEMENT].to_sym).text.strip == value
        print_to_output "value: #{value} is matched under #{key}."
      end
    end

    def get_cost_per_subject_content
      return ['Minimum', 'Expected', 'Maximum'].collect{|type| send(SELECTOR_MAPPING['Cost & Complexity Section']["#{type} Clinical Activity"]['value'][$janus::ELEMENT].to_sym).text}
    end

    def get_complexity_per_subject_content
      return ['Minimum', 'Expected', 'Maximum'].collect{|type| send(SELECTOR_MAPPING['Cost & Complexity Section']["#{type} Protocol Complexity"]['value'][$janus::ELEMENT].to_sym).text}
    end
  end

  class ProtocolComplexityChart < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Protocol Complexity']['Chart']['container'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Protocol Complexity']['Chart']['container'][$janus::SELECTOR]

    element SELECTOR_MAPPING['Protocol Complexity']['Title']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Protocol Complexity']['Title']['value'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Protocol Complexity']['Specificity & Phase']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Protocol Complexity']['Specificity & Phase']['value'][$janus::SELECTOR]

    elements SELECTOR_MAPPING['Protocol Complexity']['Legends']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Protocol Complexity']['Legends']['value'][$janus::SELECTOR]

    def verify_content(contents={})
      expected_legend = contents.select { |key, value| ['Minimum', 'Expected', 'Maximum'].include? key }.collect { |key, value| value }
      titles = contents.select { |key, value| value unless ['Minimum', 'Expected', 'Maximum'].include? key }
      chart_legend = send(SELECTOR_MAPPING['Protocol Complexity']['Legends']['value'][$janus::ELEMENT].to_sym).collect { |x| x.text.match(/\d+\.\d+/)[0] }
      titles.each do |key, value|
        raise StandardError, "Unable to find value: \"#{value}\" within Protocol Complexity chart for \"#{key}\"" unless self.send(SELECTOR_MAPPING['Protocol Complexity'][key]['value'][$janus::ELEMENT].to_sym).has_content? value
        print_to_output "value: #{value} is matched under #{key}."
      end
      raise StandardError, "Unable to validate values for \"Minimum, Expected, Maximum\" - Expected: #{expected_legend}, Found: #{chart_legend}" unless expected_legend == chart_legend
      print_to_output "\"Minimum, Expected, Maximum\" were found as #{chart_legend}"
    end
  end

  class ActivityCostChart < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Activity Cost']['Chart']['container'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['Chart']['container'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Activity Cost']['Title']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['Title']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['Activity Cost']['View Chart Details']['link'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['View Chart Details']['link'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Activity Cost']['Pie Chart']['container'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['Pie Chart']['container'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Activity Cost']['Pie']['chart'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['Pie']['chart'][$janus::SELECTOR]

    elements SELECTOR_MAPPING['Activity Cost']['Legends']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Activity Cost']['Legends']['value'][$janus::SELECTOR]


    def verify_pie(title)
      self.send("wait_until_#{SELECTOR_MAPPING['Activity Cost']['Pie Chart']['container'][$janus::ELEMENT]}_visible")
      self.send("wait_until_#{SELECTOR_MAPPING['Activity Cost']['Pie']['chart'][$janus::ELEMENT]}_visible")
      raise StandardError, "Unable to find title: \"#{title}\" for Pie chart." unless self.send(SELECTOR_MAPPING['Activity Cost']['Title']['value'][$janus::ELEMENT].to_sym).has_content? title
      print_to_output "Pie chart is shown with title: \"#{title}\" is verified"
    end

    def verify_legends(contents={})
      self.send("wait_until_#{SELECTOR_MAPPING['Activity Cost']['Pie Chart']['container'][$janus::ELEMENT]}_visible")
      chart_legend = send(SELECTOR_MAPPING['Activity Cost']['Legends']['value'][$janus::ELEMENT].to_sym).collect { |x| x.text }
      expected_legend = contents.map { |value| value['Legends'] }

      raise StandardError, "Unable to validate value for chart legends - Expected: #{expected_legend}, Found: #{chart_legend}" unless expected_legend == chart_legend
      print_to_output "Pie Chart legends verified: #{chart_legend}"
    end

  end

  class ViewChartDetailSection < StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['View Chart Details']['Container']['table'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Container']['table'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Header Row 1']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Header Row 1']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Header Row 2']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Header Row 2']['header'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Type']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Type']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Type']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Type']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Description']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Description']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Description']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Description']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Clinical Activity Site Cost per Subject']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Clinical Activity Site Cost per Subject']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Clinical Activity Site Cost per Subject']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Clinical Activity Site Cost per Subject']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Quantity']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Quantity']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Quantity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Quantity']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Site Cost of Study']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Site Cost of Study']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Site Cost of Study']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Site Cost of Study']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Protocol Complexity']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Protocol Complexity']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Protocol Complexity']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Protocol Complexity']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Protocol Complexity of Study']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Protocol Complexity of Study']['header'][$janus::SELECTOR]
    element SELECTOR_MAPPING['View Chart Details']['Protocol Complexity of Study']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Protocol Complexity of Study']['value'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Expected']['header'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Expected']['header'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Totals Row']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Totals Row']['value'][$janus::SELECTOR]

    elements SELECTOR_MAPPING['View Chart Details']['Row Objective']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Row Objective']['value'][$janus::SELECTOR]
    elements SELECTOR_MAPPING['View Chart Details']['Row Objective']['toggle-button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Row Objective']['toggle-button'][$janus::SELECTOR]

    elements SELECTOR_MAPPING['View Chart Details']['Row Other']['value'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Row Other']['value'][$janus::SELECTOR]
    elements SELECTOR_MAPPING['View Chart Details']['Row Other']['toggle-button'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Row Other']['toggle-button'][$janus::SELECTOR]

    element SELECTOR_MAPPING['View Chart Details']['Cost Analysis']['dropdown'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['View Chart Details']['Cost Analysis']['dropdown'][$janus::SELECTOR]

    def navigate_to(cost_analysis)
      self.send("wait_until_#{SELECTOR_MAPPING['View Chart Details']['Cost Analysis']['dropdown'][$janus::ELEMENT]}_visible")
      seld.send(SELECTOR_MAPPING['View Chart Details']['Cost Analysis']['dropdown'][$janus::ELEMENT].to_sym).select cost_analysis
    end

    def verify_totals(table)
      table.inject(&:merge).each do |key, value|
        raise StandardError, "Unable to find value: \"#{value}\" under View Chart Detail for \"#{key}\"" unless self.send(SELECTOR_MAPPING['View Chart Details'][key]['value'][$janus::ELEMENT].to_sym).text.strip == value
        print_to_output "value: #{value} is matched for #{key}."
      end
    end
  end


  class Analytics < Scenario
    set_url_matcher /.\/analytics*/

    def initialize
      @klass = ANALYTICS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[ANALYTICS]['Analytics Container']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Analytics Container']['panel'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['container'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['title'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['description'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['description'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['No Schedule']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['No Schedule']['container'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['No Schedule']['label'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['No Schedule']['label'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['container'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['title'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['container'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['title'][SELECTOR]
    section SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['section'][ELEMENT].to_sym, ActivityCostChart, SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['section'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['container'][SELECTOR]
    element SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['title'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['title'][SELECTOR]

    element SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['table'][SELECTOR]
    section SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['section'][ELEMENT].to_sym, ViewChartDetailSection, SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['section'][SELECTOR]

    section SELECTOR_MAPPING[ANALYTICS]['Schedule Selection']['section'][ELEMENT].to_sym, AnalyticsScheduleNavigation, SELECTOR_MAPPING[ANALYTICS]['Schedule Selection']['section'][SELECTOR]

    section SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['section'][ELEMENT].to_sym, CostComplexitySection, SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['section'][SELECTOR]

    section SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['section'][ELEMENT].to_sym, ProtocolComplexityChart, SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['section'][SELECTOR]

    def invoke_action(opt = {})
      self.send("wait_until_#{SELECTOR_MAPPING[ANALYTICS]['Schedule Selection']['section'][ELEMENT]}_visible")
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Schedule Selection']['section'][ELEMENT]}").invoke_select('Navigate', 'Schedule Selection', opt['schedule'])
      self.wait_for_no_spinner
    end

    def verify_items_in_cost_complexity_section(items = {})
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['section'][ELEMENT]}").verify_content(items)
    end

    def verify_protocol_complexity_chart_contents(items = {})
      self.wait_for_no_spinner

      self.scroll_down_container('Protocol Complexity Chart', 'section')
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Protocol Complexity Chart']['section'][ELEMENT]}").verify_content(items)
    end

    def verify_pie_present(title)
      self.wait_for_no_spinner

      self.scroll_down_container('Activity Cost Chart', 'section')
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['section'][ELEMENT]}").verify_pie(title)
    end

    def verify_activity_chart_legends(opts={})
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['section'][ELEMENT]}").verify_legends(opts)
    end

    def toggle_view_chart_details(state = true, cost_analysis = nil)
      if state
        within(SELECTOR_MAPPING[ANALYTICS]['Activity Cost Chart']['container'][SELECTOR]) do
          click_link 'View Chart Details' if page.has_content? 'View Chart Details'
        end
        self.wait_for_no_spinner
        self.send("#{SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['section'][ELEMENT]}").navigate_to(cost_analysis) if cost_analysis

        self.scroll_down_container('View Chart Details', 'section')
        self.wait_for_no_spinner
      else
        within(SELECTOR_MAPPING[ANALYTICS]['Analytics Header']['title'][SELECTOR]) do
          click_link 'Analytics' if page.has_content? 'Chart Details'
        end
      end
      self.wait_for_no_spinner
    end

    def verify_view_chart_table_total(table={})
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['View Chart Details']['section'][ELEMENT]}").verify_totals(table)
    end

    def clinical_activity_site_cost_per_subject
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['section'][ELEMENT]}").get_cost_per_subject_content
    end

    def protocol_complexity_per_subject
      self.wait_for_no_spinner
      self.send("#{SELECTOR_MAPPING[ANALYTICS]['Cost & Complexity']['section'][ELEMENT]}").get_complexity_per_subject_content
    end

  end
end
