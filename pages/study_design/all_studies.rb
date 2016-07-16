require_relative '../common/base_page'
require_relative 'selector_helper'
require_relative '../../lib/helpers/async_helper'
require_relative '../../lib/helpers/faker_helper'
require_relative 'common_design_optimization.rb'

module StudyDesign
  self.autoload?(:CommonDesignOptimization)
  class AllStudies < CommonDesignOptimization

    # capture Selectors
    element SELECTOR_MAPPING[ALL_STUDIES]['Data']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Data']['panel'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Data']['container'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Data']['container'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Data']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Data']['table'][SELECTOR]

    element SELECTOR_MAPPING[ALL_STUDIES]['Study Name']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Study Name']['header'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Protocol ID']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Protocol ID']['header'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Primary Indication']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Primary Indication']['header'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Secondary Indication']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Secondary Indication']['header'][SELECTOR]
    element SELECTOR_MAPPING[ALL_STUDIES]['Phase']['header'][ELEMENT].to_sym, SELECTOR_MAPPING[ALL_STUDIES]['Phase']['header'][SELECTOR]

    elements :all_studies_table_header_studies_rows, SELECTOR_MAPPING[ALL_STUDIES]['Studies']['row'][SELECTOR]
    elements :all_studies_table_header_studies_title, SELECTOR_MAPPING[ALL_STUDIES]['Studies']['title'][SELECTOR]
    elements :all_studies_table_header_studies_protocol, SELECTOR_MAPPING[ALL_STUDIES]['Studies']['protocol'][SELECTOR]

    set_url_matcher /.studydesign./
    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      @klass = ALL_STUDIES
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    def count(name, tag=nil)
      case name
        when /studies/
          self.wait_until_all_studies_table_header_studies_rows_visible
          return all_studies_table_header_studies_rows.count
      end
    end

    def loadStudy(study)
      self.wait_until_all_studies_table_header_studies_title_visible
      result = all_studies_table_header_studies_title.detect do |element|
        element.text == study
      end
      if result
        result.click
        sleep 0.01
      else
        raise MediTAFException "Unable to find study: #{study}"
      end
      # sleep 30
    end

    def verifyStudies(data)
      self.wait_until_all_studies_table_header_studies_rows_visible
      result = all_studies_table_header_studies_rows.detect do |element|
        data.keys.all? do |key|
          data[key]==element.find("td:nth-of-type(#{SELECTOR_MAPPING[ALL_STUDIES][key]['index']})").text
        end
      end
      if result
        data.each {|key, value| self.print_to_output "#{key} is verified as \"#{value}\""}
      else
        raise MediTAFException "Unable to verify information: #{data}"
      end
    end
  end
end
