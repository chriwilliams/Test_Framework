require_relative 'edc'
require_relative 'sections'

module Ravex
  class LogLine < Edc

    section :pagination, Pagination, 'div[class="paginate clearfix"]'
    element :new_log_line, 'a#addLog'
    element :search_field, 'select[id="search_field"]'
    element :search_by, 'input[id="search_by"]'
    element :search, 'button[id="filter_record"]'
    elements :all_log_lines, 'tr[class*="edcRow"]'
    element :activate_dialog, 'div[class="modal-dialog"]'
    element :portrait_link, 'div > a[href*="portraitLogPageRecordNumber"]'

    attr_reader :log_line

    # opens a log line by number
    # @param line_num [string] the number of the log line you want to open for edit
    def log_line_open(line_num)
      log_line_action_select(line_num, 'Edit')
    end

    # activates or inactivates a log line
    # @param line_num [string] the number of the log line you want to activate or inactivate
    # @param action [string] the action you want to take on the log line. Can be 'activate' or 'inactivate'
    # @param reason [string] the reason for the activation or deactivation of the log line
    # @param confirm [string] whether or not to press 'OK' or 'Cancel'
    def log_line_activation(line_num, action, reason = nil, confirm = 'OK')
      case action.to_s.downcase
        when 'inactivate'
          log_line_action_select(line_num, 'Inactivate')
        when 'activate', 'reactivate'
          log_line_action_select(line_num, 'Reactivate')
        else
          raise "Action: #{action} is not a valid action."
      end

      drop_down = activate_dialog.all('select').first[:id]
      select(reason, :from => drop_down) if reason

      button = activate_dialog.all('button', :text => "#{confirm}").first

      raise "Button #{confirm} is not valid" unless button

      button.click
    end

    # clicks the Add a new Log line button
    def log_line_add
      new_log_line.click
    end

    # searches for a particular log line value
    # @param field_name [string] the field name you want to search the value on
    # @param field_value [string] the value of the field
    def log_line_search(field_name = nil, field_value)
      field_name == 'All' unless field_name
      select(field_name, :from => search_field)
      search_by.set "#{field_value}"
      search.click
    end

    # changes the log form or mixed form to landscape view
    def change_to_landscape_view
      portrait_link.click
    end

    # changes the log form or mixed form to portrait view
    # @param line_num [string] the line number you wish to change to portrait view
    def change_to_portrait_view(line_num)
      log_line_find(line_num)
      log_line_item = @log_line.all(:css, 'a').first
      log_line_item.click
    end

    private

    # performs a select action on a Log Line
    # @param line_num [string] the log line number you want to perform the action on
    # @param action [string] the action you want to perform on the log line
    def log_line_action_select(line_num, action)

      log_line_find(line_num)

      @log_line.all(:css, 'button[data-toggle="dropdown"]').first.click # opens the actions menu
      action_list = @log_line.all(:css, 'ul[class="dropdown-menu pull-right"] > li > a')
      action_item = action_list.detect { |item| item.text == action }

      if action_item
        action_item.click
      else
        raise "Action: #{action} is not available for Log Line: #{line_num}."
      end
    end

    # finds the log line based on number
    # @param line_num [string] the log line number
    def log_line_find(line_num)
      log_line = all_log_lines.detect { |item| item.text.include? line_num }

      raise "Log Line #{line_num} not found." unless log_line

      log_line_val = log_line.all(:css, 'input[id$="RecordNumber"]', :visible => false).first[:value]

      if line_num.to_i == log_line_val.to_i
        @log_line = log_line
      end
    end

  end
end