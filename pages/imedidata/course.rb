require_relative '../common/base_page/'

module Imedidata
  class Course < Common::BasePage

    element :close_button, 'div#button100'
    element :next_button, '#button91'
    element :back_button, '#button90'
    element :done_button, '#button56'
    element :assessment_next, '#button52'
    element :radio_button_3, '#radio67id'
    element :checkbox_1, '#check74id'
    element :checkbox_2, '#check76id'
    element :checkbox_3, '#check78id'
    element :radio_button_2, '#radio88id'
    element :radio_button_23, '#radio154id'
    element :radio_button_33, '#radio171id'

    set_url_matcher /.courses./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Browse through the course for a specific file ('Sample _Course_For_SQA.zip')
    def browse_course
      3.times do
        next_button.click
        sleep 1
      end
      radio_button_3.click
      assessment_next.click
      sleep 1
      checkbox_1.set(true)
      checkbox_2.set(true)
      checkbox_3.set(true)
      assessment_next.click
      sleep 1
      radio_button_2.click
      assessment_next.click
      sleep 1
      radio_button_23.click
      assessment_next.click
      sleep 1
      radio_button_33.click
      assessment_next.click
      sleep 1
      done_button.click
      sleep 1
      close_button.click
      sleep 3
    end

  end
end
