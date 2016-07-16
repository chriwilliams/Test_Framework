require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Subject < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :unblind_history_table, Table '#subject_unblinding_history'

    element :subject_un_button, '#unblind_subject_button'
    element :reason, '#subject_unblind_reason'
    element :confirm, '#update_unblind'
    element :manual_dispense_button, 'button[data-href$="manual_dispensation"]'

    # Unblind a subject
    # @param reason [string] the reason for unblinding
    def unblind_subject(unblind_reson)
      subject_un_button.click
      reason.set unblind_reson
      confirm.click
    end

   end
end
