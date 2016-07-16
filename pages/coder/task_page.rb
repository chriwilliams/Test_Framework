require_relative '../common/base_page'
require_relative 'sections'
require 'time'

module Coder
  class TaskPage < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    elements :all_rows, 'table[id$="gridElements_DXMainTable"] > tbody > tr > td:nth-child(1)'
    elements :all_buttons, 'a[id*="Content_UpActions"]'

    element :iMedidata_App_Container, '#apps'
    element :iMedidata, 'iMedidata'
    element :task_header, 'table.HeaderTable > tbody > tr > td:nth-child(1) > span'  # Text. X Coding Task Found
    element :main_table, 'table[id$="gridElements_DXMainTable"]'
    element :source_system, 'select[id$="DdlSourceSystems"]'       #dropdown
    element :study_selection, 'select[id$="DdlTrackables"]'        #dropdown
    element :task_view_selection, 'select[id$="DdlMultiView"]'     #dropdown
    element :open_query, 'a[id*="Actions__Btn_2621"]'              #button
    element :close_icon, '[id$="Content_pcReason_HCB-1Img"]'       #image
    element :query_comment, 'textarea[id$="txtComment"]'                                #edit_field
    element :filter, '#MainContent > div.master-content > table:nth-child(5) > tbody > tr > td:nth-child(1) > a.clBtn.clBtnIcon'                                      #link/button
    element :clear_filter, 'a[id$="clearFilters"]'                  #button/link
    element :verbatim_search_box, 'input$=["TxtSearch"]'           #edit_field
    element :browser, 'Browser'                                    #link
    elements :details_tabs, '[id*="Content_tab"]'
    element :ok_button, 'a[id$="pcReason_BtnActionOk"]'
    elements :table_rows, 'td[id$="gridElements_DXDataRow"]'
    elements :coder_main_table_rows, 'table[id$="gridElements_DXMainTable"] > tbody > tr'
    elements :reference_rows, 'tr[id^="gridReference_DXDataRow"]' #reference table rows
    element :search_term_field, 'input[id$="TxtSearch"]'
    element :search_button, 'a[class*="clBtn clBtnIcon"]'
    elements :supplement_rows, 'tr[id^="gridSupplemental_DXDataRow"]' #supplements table rows
    element :page_pagination, 'table[id*="gridElements_DXPagerBottom"] > tbody > tr > td > table > tbody > tr'
    element :task_table, 'table[id$="gridElements_DXMainTable"] > tbody'
    element :select_segment, 'select[id$= "ddlSegment"]'



    # this method will wait for coder page to load within Capybara timeout (30 seconds).
    # it verifies that a filter button is displayed on the UI as a verification of coder page being loaded once navigated from iMedidata
    def verify_coder_is_loaded
      if clear_filter.visible?
        clear_filter.click
        sleep 1
        clear_filter.click
        wait_for_clear_filter
      else
        sleep 2
        puts "Waited #{Capybara.default_wait_time} seconds for coder to load it was still not responding. Test may continue ..."
      end
    end

    # this is to search for a term in coder main table
    # @param [String] term to search for. For a positive result, you must pass in the exact verbatim term
    def search_for_term(term)
      wait_for_search_term_field
      search_term_field.set term
      page.click_link('Search Task')
      wait_for_all_rows
    end

    # this method will return how many tasks are displayed in the tasks page.
    def get_number_of_tasks
      clear_filter.click
      sleep 3
      task_found_array = task_header.text.split
      task_found = task_found_array[0].to_i
      task_found
    end

    # this method acts as a synchronization point for tasks to load in task page.
    #@param  task_num [Integer]: expected number of tasks to show up in coder page
    def verify_task_num(task_num)
      num = task_num.to_i
      try = 0
      while try <= 60
        clear_filter.click
        sleep 10
        task_found = task_header.text.split[0].to_i
        return if task_found >= num
        try += 1
      end
      raise "Expected number of tasks not found after 10 mins"
    end

    def verify_vb_term(vb_term)
      wait_for_coder_main_table_rows
      row = all_rows.detect { |item| item.text.downcase == vb_term.downcase }
      raise "Verbatim Term #{vb_term} not found on the page" unless row
    end

    def select_action_for_row(workflow_action, row_number)
      sleep 2
      all_rows.at(row_number.to_i).click
      sleep 2
      select_workflow_action(workflow_action)
    end

    def verify_term_and_select_row(vb_term, row)
      verify_vb_term(vb_term)
      all_rows.at(row.to_i).click
      sleep 1
    end
    # Selects tab with details
    # @param tab_name [string] name of tab: "Source Terms", "Properties", "Assignments", "Coding History", "Query History"
    def select_details_tab(tab_name)
      wait_for_details_tabs
      tab = details_tabs.detect{|item| item.text.downcase == tab_name.downcase}
      if tab
        tab.click
      else
        raise "Unrecognized tab selection: '#{tab_name}' provided! Also, make sure a term is selected for the tabs to populate dynamically!"
      end
    end

    # this method
    def open_query(query_text)
      wait_for_coder_main_table_rows
      sleep 1
      select_workflow_action 'Open Query'
      query_comment.set query_text
      ok_button.click
      clear_filter.click
      wait_for_coder_main_table_rows
    end

    # this method verifies that an expected query status is reached as a synchronization point for a specific term
    # @param row [Integer] row number to look at in the Coder Main Table
    # @param term [String] term to look at for which we are looking into to verify the query status
    # @param status [String] expected query staus [Example: Queued, Open, Cancle, Closed]
    def verify_query_status(row, term, status)
      counter = 1
      found = false
      look_up_row = (row.to_i - 1)
      while counter <= 25 and get_cell_data_by_xpath(look_up_row,7) != status.downcase
        search_for_term term
        coder_main_table_rows.each do |row|
          row_text = row.text.downcase
          if row_text.include? term.downcase
            if get_cell_data_by_xpath(0,7) == status.downcase
              found = true
              break if found == true
            else
              clear_filter.click
              sleep 5
              counter += 1
            end
          end
        end
      end
      raise get_cell_data_by_xpath(look_up_row,7) + ' does NOT match with expected data: ' + status.downcase if get_cell_data_by_xpath(0,7) != status.downcase
    end

    # Returns corresponding to the specified name value from the Reference Table
    #@param name [string] the name from the Reference table
    def get_reference_value(name)
      page.driver.browser.switch_to.frame('FrmSourceTerm')
      row  = reference_rows.detect{|item| item.text.include? name}
      actual_value = ''
      actual_value = get_value_by_name(row) if row
      page.driver.browser.switch_to.default_content
      actual_value
    end

    # Returns corresponding to the specified name value from the Supplements Table
    #@param name [string] the name of Supplemental Term from the Supplements table
    def get_supplement_value(name)
      page.driver.browser.switch_to.frame('FrmSourceTerm')
      row  = supplement_rows.detect{|item| item.text.include? name}
      actual_value = ''
      actual_value = get_value_by_name(row) if row
      page.driver.browser.switch_to.default_content
      actual_value
    end

    # searches for a term and makes sure it appears in coder main table within 2 minutes
    # @param term [String] verbatim term you are looking for. The search needs to meet Coder search requirements.
    def wait_for_term(term)
      found, retry_attempt = false, 0
      while !found && retry_attempt < 40
        search_for_term term
        if all_rows.at(1).text.downcase == term.downcase
          all_rows.at(1).click
          wait_for_all_buttons
          found = true
          break
        else
          sleep 3
          retry_attempt += 1
          clear_filter.click
        end
      end
      raise "Term Not Found after 120 seconds! Hmm... web service sucks maybe? :D" if found == false
    end

    # Verifies an expected term does not appear in Coder Main Table. Raises error when the term appears on table
    # @param vb_term [String] term not expected to be seen in Coder Main Table
    def verify_vb_term_not_there(vb_term)
      wait_for_coder_main_table_rows
      all_rows.detect do |item|
        raise item.text.upcase + ' expected not to appear on Coder Main Table. But it appears!' if item.text.downcase == vb_term.downcase
      end
    end

    # selects a link within the task table
    # @param [String] name of the link as it appears on the UI.
    def select_coded_term_link(link_name)
      coded_links = task_table.all(:css, 'a', text, "#{link_name}")
      coded_links.first.click
    end

    # selects segment from dropdown
    def select_seg(seg_name)
      select_segment.select seg_name
    end

    private
    def get_value_by_name(row)
      values = row.all(:css, 'td[class="dxgv"]')
      actual_value = values.last.text
    end

    def select_workflow_action(action)
      button = all_buttons.detect { |item| item.text.downcase.include? action.downcase }
      raise "Button for workflow action #{action} not found" unless button
      button.click
    end

    def get_cell_data_by_xpath(row, column)
      xpath = "//*[@id='ctl00_Content_gridElements_DXDataRow#{row}']/td[#{column}]"
      value =  find(:xpath, xpath).text
      value.downcase
    end

    # Finds out how many pages of task are there in coder main table
    # @return [Integer] number of pages as an integer
    def task_page_pagination
      texts = page_pagination.text #find('table[id*="gridElements_DXPagerBottom"] > tbody > tr > td > table > tbody > tr').text
      pages = (texts.split('Next'))
      page_number = pages[0].split.last.to_i
      page_number
    end
  end
end
