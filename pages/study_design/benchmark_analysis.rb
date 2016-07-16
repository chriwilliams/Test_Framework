require_relative 'home'
require_relative 'study_design_section'

module StudyDesign

  class BenchmarkAnalysis < Scenario
    set_url_matcher /.\/benchmark-analysis*/

    def initialize
      @klass = BENCHMARK_ANALYSIS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element :benchmark_analysis_page_schedule_selector_button, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Schedule Selector']['button'][SELECTOR]
    element :benchmark_analysis_page_schedule_selector_label, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Schedule Selector']['label'][SELECTOR]
    element :benchmark_analysis_page_schedule_selector_dropdown, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Schedule Selector']['dropdown'][SELECTOR]
    element :benchmark_analysis_page_active_schedule_title, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Active Schedule']['title'][SELECTOR]

    element :benchmark_analysis_page_indication_selector_button, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Indication Selector']['button'][SELECTOR]
    element :benchmark_analysis_page_indication_selector_label, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Indication Selector']['label'][SELECTOR]
    element :benchmark_analysis_page_indication_selector_dropdown, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Indication Selector']['dropdown'][SELECTOR]
    element :benchmark_analysis_page_indication_selector_list, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Indication Selector']['list'][SELECTOR]

    element :benchmark_analysis_container_header, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Container']['header'][SELECTOR]
    element :benchmark_analysis_container_panel, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Container']['panel'][SELECTOR]

    element :benchmark_analysis_specificity_title, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Specificity']['title'][SELECTOR]
    element :benchmark_analysis_specificity_label, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Specificity']['label'][SELECTOR]

    element :benchmark_analysis_data_volume_title, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Data Volume']['title'][SELECTOR]
    element :benchmark_analysis_data_volume_label, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Data Volume']['label'][SELECTOR]

    element :benchmark_analysis_summary_benchmarks_title, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Summary Benchmarks']['title'][SELECTOR]
    element :benchmark_analysis_summary_benchmarks_panel, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Summary Benchmarks']['panel'][SELECTOR]

    element :benchmark_analysis_activity_benchmarks_title, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Activity Benchmarks']['title'][SELECTOR]
    element :benchmark_analysis_activity_benchmarks_panel, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Activity Benchmarks']['panel'][SELECTOR]

    element :benchmark_analysis_upper_summary_benchmark_table, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Upper Summary Benchmark']['table'][SELECTOR]
    element :benchmark_analysis_lower_summary_benchmark_table, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Lower Summary Benchmark']['table'][SELECTOR]

    element :benchmark_analysis_activity_benchmarks_table, SELECTOR_MAPPING[BENCHMARK_ANALYSIS]['Activity Benchmarks']['table'][SELECTOR]

    # This method selects a new schedule based on name.
    # Note: If the name is selected it will not attempt to navigate. The assumption made is that each schedule name is unique.
    # @param schedule_name [String] the Schedule name to switch.
    def navigate_to_schedule(schedule_name)
      self.wait_for_no_spinner

      wait_until_benchmark_analysis_page_schedule_selector_label_visible
      unless (benchmark_analysis_page_schedule_selector_label.text == schedule_name)
        benchmark_analysis_page_schedule_selector_button.click
        wait_until_benchmark_analysis_page_schedule_selector_dropdown_visible
        benchmark_analysis_page_schedule_selector_dropdown.all('li a',text: schedule_name).first.click

        self.wait_for_no_spinner
        MIST::AsyncHelper.wait_until{(benchmark_analysis_page_active_schedule_title.text == schedule_name)}
      end
    end


    # This method selects a new indication based on indication value or title
    # Options:
    # The user can pass either Primary or Secondary to indicate the indication for selection.
    # The user can also provide the entire indication title for selection
    # @param indication_name [String] the Indication selection to switch.
    def select_indication(indication_name)
      unless benchmark_analysis_page_indication_selector_label.text =~ /#{indication_name}/
        benchmark_analysis_page_indication_selector_button.click
        wait_until_benchmark_analysis_page_indication_selector_dropdown_visible
        benchmark_analysis_page_indication_selector_dropdown.all('li a',text: indication_name).first.click

        self.wait_for_no_spinner
        MIST::AsyncHelper.wait_until{(benchmark_analysis_page_indication_selector_label.text =~ /#{indication_name}/) != nil}
      end
      self.print_to_output "Indication: \"#{benchmark_analysis_page_indication_selector_label.text}\" is selected."
    end
  end
end
