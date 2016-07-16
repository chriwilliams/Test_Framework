require_relative '../common/base_page'
require_relative 'sections'

  module Ravex
    class Site < Common::BasePage
      section :header, Header, '#header'
      section :navigation, Navigation, '#navigation'
      section :subject_header, SubjectHeader, 'div[class="page-header page-header-main clearfix"]'
      section :pagination, Pagination, 'div[class="paginate clearfix"]'

      element :add_subject_button, 'a#add-candidate-button'
      element :task_list_button, 'span[class*="glyphicon glyphicon-list-alt"]'
      element :subject_list_link, 'a[href*="SubjectList"]'
      elements :subject_rows, '#minotaur-table > tbody > tr'

      set_url_matcher /.checkmate./

      # Clicks on "Add Subject" button
      def add_subject
        add_subject_button.click
      end

      # Clicks on "Task List" button
      def task_list_open
        #task_list_button = buttons.detect {|item| item.text == "Task List"}
        task_list_button.click
      end

      # Searches for the specified subject
      # @param subject_name [string] subject name to search for
      def search_subject(subject_name)
        search_field.set subject_name
        sleep 1
        if search_button
          search_button.click
        else
          raise 'Search button is not available on the page. Please make sure the search criteria is populated.'
        end
      end

      # Opens the first subject with specified name.
      # @param subject_name [string] subject name to open
      def open_subject(subject_name)
        subject_row = subject_rows.detect {|item| item.text.include? subject_name}

        raise "Subject #{subject_name} not found" unless subject_row

        subject_row.click
      end

      # Click "Clear search" list to clear search results for subject search.
      def clear_search
        clear_search_link.click
      end

    end
  end