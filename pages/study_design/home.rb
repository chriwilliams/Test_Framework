require_relative '../common/base_page'
require_relative 'selector_helper'
require_relative '../../lib/helpers/async_helper'
require_relative '../../lib/helpers/faker_helper'
require_relative 'common_design_optimization.rb'

module StudyDesign
  self.autoload?(:CommonDesignOptimization)
  class Home < CommonDesignOptimization

    # capture Selectors
    element :page_header, SELECTOR_MAPPING['Page']['Header']['title'][SELECTOR]
    element :read_only_badge, SELECTOR_MAPPING['Page']['Header']['badge'][READ_ONLY]

    # set_url_matcher /checmate.imedidata.study_design/

    set_url_matcher /.studydesign./
    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      @klass = 'HOME'
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    #Common Properties

    # Returns the title of current page
    def pageTitle
      (self || Home.new).title
    end

    # Returns Boolean whether the page has read only information
    # @param text [String] optional parameter to verify statement on page
    # #return [Boolean] stating whether page can be accessed
    #
    def verifyPageIsReadOnly(text = nil)
      self.wait_until_read_only_badge_visible

      return read_only_badge.text == 'Read-Only'
    end

    # Returns the title of the study
    def studyTitle
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { page_header.visible? }
      sleep 1 #TODO Refactor methods, steps are failing due to recent update from imedidata
      $async::wait_until($janus::WAY_TOO_LONG_TO_LOAD) { !page_header.text.empty? }
      page_header.text
    end

    # This method allows to wait for a spinner to terminate animation
    def wait_for_no_spinner
      sleep 0.01
      within(:xpath, '//html/body') do
        SitePrism::Waiter.wait_until_true { page.has_no_css? '.fa-spinner' }
        SitePrism::Waiter.wait_until_true { page.has_no_css? '.fa-spin' }
        SitePrism::Waiter.wait_until_true { page.has_no_css? '.blockUI' }
        SitePrism::Waiter.wait_until_true { page.has_no_css? '.blockMsg' }
        SitePrism::Waiter.wait_until_true { page.has_no_css? '.blockPage' }
      end
      sleep 0.01
    end

  end
end
