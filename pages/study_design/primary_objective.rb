require_relative 'home'
require_relative 'objective'

module StudyDesign
  self.autoload?(:Objective)
  class PrimaryObjective < Objective
    set_url_matcher /.studydesign./

    def initialize(data = nil)
      @page_container_list = SELECTOR_MAPPING[OBJECTIVE]['Primary']
      add_objective(data) unless data.nil?
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end
  end
end
