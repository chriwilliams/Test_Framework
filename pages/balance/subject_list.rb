require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class SubjectList < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :notifications, Notifications, 'body'
    section :subjects_table, Table, '#subject_list'

    element :subject_download_list, '#download_button' #button
    elements :subject_distribution_report, 'a[href$="distribution_report"]' #link
    elements :subject_treatment_report, 'a[href$="treatment_report"]' #link
    element :subject_id, '#subject_identifier' #input text field
    element :apply, '#apply_button' #button
    element :reset, '#reset_button' #button
    elements :subjects, '#subject_list td.external_id a'

    # Search for a specific subject
    # @param sub_id [string] the id of the subject
    def search_subject(sub_id)
      reset.click
      subject_id.set sub_id
      apply.click
    end

    # Select a specific subject
    # @param sub_id [string] the id of the subject
    def subject_select(sub_id)
      search_subject(sub_id)
      index = get_element_index(subjects, sub_id)
      subjects[index].click
    end
  end
end
