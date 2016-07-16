require_relative '../common/base_section'

module Balance
  
  class MainNav <  Common::BaseSection
    elements :main_tabs, '#main_tab a'

    def select_main_nav(nav_option)
      index = get_element_index(main_tabs, nav_option)
      selection = main_tabs[index]

      selection.click unless selection[:class] == "pebble_link"
    end
  end

  class SubNav < Common::BaseSection
    elements :sub_tabs, '#tabs a'
    element :current_tab, "#tabs li[class^='current']"

    def select_sub_nav(nav_option)
      index = get_element_index(sub_tabs, nav_option)

      sub_tabs[index].click unless current_tab.text == nav_option
    end

  end

  class Calendar < Common::BaseSection
    elements :calendar_trigger, '.ui-datepicker-trigger' #image
    element :month, '.ui-datepicker-month'
    element :year, '.ui-datepicker-year'
    elements :days, '.ui-datepicker-calendar a'

    # sets the date in the calendar date picker
    # @param date [string] the date to set, format: 10 Jan 2018
    def select_date(date, iterator=0)
      my_date = Date.parse(date)
      calendar_trigger[iterator].click
      month.select Date::ABBR_MONTHNAMES[my_date.month]
      year.select my_date.year
      days.each do |d|
        if d.text == my_date.mday.to_s
          d.click
          break
        end
      end
    end
  end

  class Header <  Common::BaseSection
    element :balance_logo, '#balance_logo'  #image/link
    element :logout,  '#logout' #link
    element :imedidata_logo, '#imedidata_logo'  #image/link
  end


  class Table < Common::BaseSection
    elements :headers, 'th' #collection table headers
    elements :rows, 'tr' #collection of table rows

    # Gets the row index of the pivot row
    # @param header_name [string] the header of the column you wish to search
    # @param row_cell [string] the name of the cell you wish to locate
    # @param raise_error [boolean] raise and error if not found, true by default
    def get_row_index(header_name, row_cell, raise_error=true)
      header_index = get_header_index(header_name)

      rows.each_with_index do |row, index|
        tds = row.all(:css, 'td')
        if tds.empty?
          tds = row.all(:css, 'th')
        end

        return index if tds[header_index].text == row_cell
      end
      raise "Could not find #{row_cell} under column #{header_name}" if raise_error
    end

    # Gets the index of the header
    # @param header_name [string] the name of the header column
    def get_header_index(header_name)
      get_element_index(headers, header_name)
    end

    # Verifies a cell in a table
    # @param pivot_header [string] the text of the header of the pivot column
    # @param pivot_cell [string] the text of the cell of the pivot row
    # @param verify_header [string] the header of the cell you wish to verify
    # @param verify_cell [string] the text of the cell you wish to verify
    def verify_cell(pivot_header, pivot_cell, verify_header, verify_cell)
      pivot_index = get_row_index(pivot_header, pivot_cell)
      header_index = get_header_index(verify_header)
      cell_text = get_cell_text(header_index, pivot_index)

      if verify_cell != cell_text
        raise "Cell did not match. \nPassed: #{verify_header}-#{verify_cell} \nFound: #{verify_header}-#{cell_text}"
      end
    end

    # Returns the text of a specified cell in a table
    # @param header_index [integer] the index of your header(column)
    # @param row_index [integer] the index of your row
    def get_cell_text(header_index, row_index)
      rows[row_index].all('td')[header_index].text
    end

    # Verify the contents of your passed table to the webtable
    # @param content_table [Cucumber::Ast::Table] the table you wish to verify
    def verify_contents(content_table)
      content_headers = content_table.shift

      content_table.each_with_index do |row|
        row.each_with_index do |cell, index|
          verify_cell(content_headers[0], row[0], content_headers[index], cell)
        end
      end
    end

  end

  class Notifications < Common::BaseSection
    elements :all_notifications, 'div[id*="notification_"]'
    elements :all_flash_notice, 'div[id*="flash-"]'

    # verify flash notification message
    # @param exp_msg_text [string] expected message text
    def verify_notifications(exp_msg_text)
      msg_found = false
      all_notifications.each do |msg|
        if msg.text.include? exp_msg_text
          msg_found = true
        end
        msg.find_link('Close Message').click
      end
      raise "Message '#{exp_msg_text}' not found" unless msg_found
    end

    # verify flash notification message
    # @param exp_msg_text [string] expected message text
    def verify_flash(exp_msg_text)
      msg_found = false
      all_flash_notice.each do |msg|
        if msg.text.include? exp_msg_text
          msg_found = true
        end
      end
      raise "Message '#{exp_msg_text}' not found" unless msg_found
    end
  end
end
