require_relative 'crf_page'

module Rave
  class Subject < CrfPage

    elements :subject_text_fields, 'input[name*="CRFControl_Text"]'
    element :save_button, 'input[id$="footer_SB"]'
    element :cancel_button, 'input[id$="_footer_CB"]'
    element :sign_and_save_button, 'button#SignAndSaveButton'
    elements :texts, 'input[id$="CRFControl_Text"]'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Clicks Save button on Subject Enrollment page
    def subject_save
      self.save_button.click
    end

    # Clicks Cancel button on Subject Enrollment page
    def subject_cancel
      self.cancel_button.click
    end

    # Clicks Sign and Save button on Subject Enrollment page
    def subject_sign_and_save
      self.sign_and_save_button.click
    end

    # Returns the subject name.
    def get_subject_name
      navigation_tabs.all_tabs.last[:title]
    end

  end
end