require_relative 'common_page'

module Mccadmin

  class UsersUpload < Mccadmin::CommonPage

    element :browse_button, '#study_users_upload_candidates_file'
    element :upload_file_button, '#upload-file'
    element :upload_users_button, '#field-mapping-confirmation'
    element :exit_upload_button, '#quit-upload-button'
    element :add_user_now_button, '#add-now-button'

    element :field_mapping_confirmation_button, '#field-mapping-confirmation'
    element :add_confirmation_button, '#add-confirmation'
    element :quit_upload_confirmation_button, '#quit-upload-confirm'
    element :ready_for_review, '#ready-for-review-box-users'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Adds site from the Review screen
    def add_user_now
      if ready_for_review.text.include?("Ready for Review")
        add_user_now_button.click
        add_confirmation_button.click
      else
        raise "unable to find Ready for Review text"
      end
    end

  end

end
