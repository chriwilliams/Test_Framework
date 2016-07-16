require_relative 'home'

module StudyDesign
  class NoScheduleBenchmarkAnalysis < Scenario
    set_url_matcher /.\/benchmark-analysis*/

    def initialize
      @klass = NO_SCHEDULE_NO_SCHEDULE_BENCHMARK_ANALYSIS
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['header'][SELECTOR]
    element SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['panel'][SELECTOR]
    element SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['description'][ELEMENT].to_sym, SELECTOR_MAPPING[NO_SCHEDULE_BENCHMARK_ANALYSIS]['Container']['description'][SELECTOR]
  end
end

