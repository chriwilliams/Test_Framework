require_relative '../common/base_page'

module Coder

  class AssignWorkflowRole < Common::BasePage

    element :select_user, 'input[id*="DXEditor0_I"]'
    element :select_study, 'input[id*="DXEditor1_I"]'
    element :select_role, '[id*="DXEditor3_B-1Img"]'
    element :add_new, 'a[id$="LnkAddNewgridUsrObjWflRole"]'
    elements :user_options, 'table[id$="DXEditor0_DDD_L_LBT"] > tbody > tr > td'
    elements :study_options, 'table[id*=DXEditor1] > tbody > tr > td > div > table > tbody > tr'
    elements :role_options, 'table[id$="DXEditor3_DDD_L"] > tbody > tr > td > div > table > tbody > tr'


    # this method is to assign a workflow role to a user
    # @param user [String], study [String], role [String]
    def assign_workflow_role(user, study, role)
      self.add_new.click
      select_user.click
      select_from_dropdown(:user, user)
      select_study.click
      select_from_dropdown(:study, study)
      select_role.click
      select_from_dropdown(:role, role)
      page.first('.dxgvCommandColumnItem_Main_Theme').click
      sleep 3
    end

    private
    # this is a helper method to find and select desired value
    # @param field [String], value [String]
    def select_from_dropdown(field, value)
      sleep 3
      found_value = case field
                      when :user
                        user_options.detect{ |item| item.text.downcase.include? value.downcase }
                      when :study
                        study_options.detect {|item| item.text.downcase.include? value.downcase}
                      when :role
                        role_options.detect  { |item| item.text.downcase.include? value.downcase }
                      else
                        raise 'Please provide a valid input. One of the following is valid: [:user, :study, :role]'
                    end

      raise "Value #{value} for field #{field.to_s} not found" unless found_value
      found_value.click
      sleep 2
    end
  end
end
