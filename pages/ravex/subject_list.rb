require_relative '../common/base_page'
require_relative 'sections'

module Ravex
  class SubjectList < Common::BasePage

    elements :subjects, '#subjects-table a>div'
    element :search, '#subject_filter'
    element :submit_search, '.input-group [type="submit"]'


    # Search for specific subject id
    # @param subject_id [string] the id of the subject
    def search_subject(subject_id)
      search.set subject_id
      submit_search.click
    end

    # Select a specific subject
    # @param subject_id [string] the id of the subject
    def select_subject(subject_id)
      search_subject(subject_id)
      index = get_element_index(subjects, subject_id)
      subjects[index].click
    end

  end

end

