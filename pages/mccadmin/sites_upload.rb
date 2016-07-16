require_relative 'common_page'

module Mccadmin

  class SitesUpload < Mccadmin::CommonPage
    # Elements and methods for 'Upload Sites' page

    element :browse_button, '#study_sites_upload_candidates_file'
    element :upload_file_button, '#upload-file'
    element :upload_sites_button, '#field-mapping-confirmation'
    element :exit_upload_button, '#quit-upload-button'
    element :add_site_now_button, '#add-now-button'
    element :field_mapping_confirmation_button, '#field-mapping-confirmation'
    element :add_confirmation_button, '#add-confirmation'
    element :ready_for_review, '#ready-for-review-box-sites'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Adds site from the Review screen
    def add_site_now
      if ready_for_review.text.include?("Ready for Review")
        add_site_now_button.click
        add_confirmation_button.click
      else
        raise "unable to find Ready for Review text"
      end
    end

  end
end
