require_relative '../common/base_page'

module Balance

  class Wizard < Common::BasePage

    # rand type options
    element :rand_only, '#modal #study_type_rand_only' #radio button
    element :rand_and_supply, '#modal #study_type_rand_log' #radio button

    # blinding options
    element :blind_yes, '#modal #blinding_yes' #radio button
    element :blind_no, '#modal #blinding_no' #radio button

    # design import options
    element :scratch_design, '#modal #design_setup_from_scratch' #radio button
    element :import_design, '#modal #design_setup_import' #radio button
    element :import_dropdown, '#modal #design_import_select' #dropdown

    # rand design option
    element :dynamic_allocation, '#modal #rand_type_dynamic_with_complete_randomization' #radio button
    element :permuted_block, '#modal #rand_type_block' #radio button

    # quarantine options
    element :quarantine_yes, '#modal #quarantine_yes' #radio button
    element :quarantine_no, '#modal #quarantine_no' #radio button
    element :file_upload_yes, '#modal #file_upload_rule_yes' #radio button
    element :file_upload_no, '#modal #file_upload_rule_no' #radio button
    element :file_upload_require, '#modal #file_upload_rule_require' #radio button

    # capping options
    element :cap_yes, '#modal #capping_yes' #radio button
    element :cap_no, '#modal #capping_no' #radio button

    # buttons
    element :nextBtn, '#nextButton' #button
    element :back, '#backButton' #button

    #general
    element :step_indicator, '#modal #step_indicator' #text label

    # Completes the study wizard based on the provided options table
    # @param options_table [table] table with study wizard options
    def select_wizard_options(options_table)
      options_table.raw.each { |row|
        case row[0]
          when 'Study Design'
            row[1] == 'Randomization Only' ? rand_only.click : rand_and_supply.click
            nextBtn.click
          when 'Blinding Restrictions'
            row[1] == 'Yes' ? blind_yes.click : blind_no.click
            nextBtn.click
          when 'Design Setup'
            if row[1] == 'Start from scratch'
              scratch_design.click
            else
              import_design.click
              import_dropdown.select row[2]
            end
            nextBtn.click
          when 'Randomization Type'
            row[1] == 'Dynamic Allocation' ? dynamic_allocation.click : permuted_block.click
            nextBtn.click
          when 'Quarantining'
            row[1] == 'Yes' ? quarantine_yes.click : quarantine_no.click
            nextBtn.click
          when 'Enrollment Caps'
            row[1] == 'Yes' ? cap_yes.click : cap_no.click
            page.execute_script("window.onbeforeunload = null;")
            nextBtn.click
          else
            raise "#{row[0]} is not a valid option to choose from in the wizard design"
        end
      }
      nextBtn.click
    end


  end
end