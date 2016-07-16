require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class CodeCleanupPage < Common::BasePage

    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :remove_proj_reg, 'input[id$="chkResetStudyRegistration"]'
    element :remove_proj_reg_and_syn_list, '[id$="chkResetSynonymState"]'
    element :clean_up_tasks,'a[id$="btnCleanup"]'                                #button
    element :odm_file_input, 'input[id$="fileUpload"]'                           #input
    element :odm_file_upload_button, 'a[id$="btnPopulate"]'                      #button
    element :csv_file_upload_button, 'a[id$="btnPopulateCsv"]'                   #text_field / edit_field
    element :clean_up_success_message, '#ctl00_StatusPaneACG_SuccessPane > div > div > div > table > tbody > tr > td:nth-child(1) > span'

    def remove_synonym_proj_reg
      #remove_proj_reg_and_syn_list.check
      (remove_proj_reg_and_syn_list).set (true)
      clean_up_tasks.click
      if
        clean_up_success_message.text == '/All the Coding Tasks have been removed/'
      else
        sleep 5 # putting extra 5 seconds for the segment to be cleaned just in case the segment has a large list of data.
      end
    end

    # checks to see if the file is there in the specified location. When file found it uploads the file
    # @param file_path [String] the specified file to upload
    def upload_an_odm(file_path)
      if File.exist?("#{file_path}")
        self.odm_file_input.attach_file(file_path) # theoretically it should work but have not tested out yet.
      else
        raise 'File not found or file does not exist'
      end
    end

    # Cleans up coding tasks in code clean up page. Performs as 'Dat Clear' in Coder
    # When code celan up does not succeeds, it will raise an error.
    def clean_up_coding_tasks
      wait_for_clean_up_tasks
      clean_up_tasks.click
      wait_for_clean_up_success_message
      raise "Error occured while cleaning up coding tasks" if !clean_up_success_message.text.include? 'All the Coding Tasks have been removed'
    end

  end
end

