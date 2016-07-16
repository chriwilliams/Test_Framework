require_relative '../common/base_page'

module Coder

  class AssignGeneralRole < Common::BasePage

    element :select_user, 'input[id*="DXEditor0_I"]'
    element :select_study, 'input[id*="DXEditor1_I"]'
    element :select_dictionary, 'input[id*="DXEditor1_I"]'
    element :select_segment, 'input[id*="DXEditor1_I"]'
    element :select_role, '[id*="DXEditor3_B-1Img"]'
    element :add_new, 'a[id$="LnkAddNewgridUsrObjRole"]'
    elements :user_options, 'table[id$="DXEditor0_DDD_L_LBT"] > tbody > tr > td'
    elements :study_options, 'table[id=ctl00_Content_gridUsrObjRole_DXEditor1_DDD_L_LBT] > tbody > tr'
    elements :dictionary_options, 'table[id$=DXEditor1_DDD_L_LBT] > tbody > tr'
    elements :segment_options, 'table[id$=DXEditor1_DDD_L_LBT] > tbody > tr'
    elements :role_options, 'table[id$="DXEditor3_DDD_L"] > tbody > tr > td > div > table > tbody > tr'
    element  :assign_to_user, :xpath, "//*[@id='ctl00_Content_gridUsrObjRole_DXEditingRow']/td[5]/img[1]" # couldn't find a better way to find the element yet
    element :security_module, '[id*="Content_DdlModules"]'


    # this method is to assign a general study role to a user
    # @param user [String], study [String], role [String]
    def assign_general_study_role(user, study, role)
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

    # this method is to assign a general dictionary role to a user
    # @param user [String], study [String], role [String]
    def assign_general_dict_role(user, dict, role)
      self.add_new.click
      select_user.click
      select_from_dropdown(:user, user)
      select_study.click
      select_from_dropdown(:study, dict)
      select_role.click
      select_from_dropdown(:role, role)
      page.first('.dxgvCommandColumnItem_Main_Theme').click
      sleep 3
    end



    # this method is to select a module before assigning a user to any module.
    # @param: select_module [String]
    def select_security_module(select_module)
      security_module.select select_module
    end

    # this method is to assign a user to a study with a role
    # @param user [String]. Pass in a user to whom access in being granted.
    # @param study [String]. Pass in the study the user will have access to.
    # @param role [String]. Pass in the role you would like to assign to the user.
    def assign_study_role(user, study, role)
      self.add_new.click
      assign_user user
      assign_study study
      assign_role role
      assign_to_user.click
    end

    # this method is to assign a user to a dictionary or all dictionaries with a role
    # @param user [String]. Pass in a user to whom access in being granted.
    # @param dictionary [String]. Pass in the dictionary the user will have access to.
    # @param role [String]. Pass in the role you would like to assign to the user.
    def assign_dictionary_role(user, dictionary, role)
      self.add_new.click
      assign_user user
      assign_dictionary dictionary
      assign_role role
      assign_to_user.click
    end


    # this method is to assign a user to a segment with a role
    # @param user [String]. Pass in a user to whom access in being granted.
    # @param segment [String]. Pass in the segment the user will have access to.
    # @param role [String]. Pass in the role you would like to assign to the user.
    def assign_segment_role(user, segment, role)
      self.add_new.click
      assign_user user
      assign_segment segment
      assign_role role
      assign_to_user.click
    end

    private

    # this method is to select a value from the drop-down list [since the drop-down list is not a regular drop-down]
    # @param: field [String], value [String]
    def select_from_dropdown(field, value)
      sleep 3
      found_value = case field
                      when :user
                        user_options.detect{ |item| item.text.downcase.include? value.downcase }
                      when :dictionary
                        dictionary_options.detect { |item| item.text.downcase.include? value.downcase }
                      when :segment
                        segment_options.detect { |item| item.text.downcase.include? value.downcase }
                      when :study
                        study_options.detect { |item| item.text.downcase.include? value.downcase }
                      when :role
                        role_options.detect  { |item| item.text.downcase.include? value.downcase }
                      else
                        raise 'Please provide a valid input. One of the following is valid: [:user, :study, :role]'
                    end

      raise "Value #{value} for field #{field.to_s} not found" unless found_value
      found_value.click
      sleep 2
    end

    # this method is used to select a study from the study drop-down on general role assignment page
    # @param: study [String]
    def assign_study(study)
      select_study.click
      assign_study = study.downcase
      select_from_dropdown(:study, assign_study)
    end

    # this method is used to select a user from the user drop-down on general role assignment page
    # @param: user [String]
    def assign_user(user)
      select_user.click
      select_from_dropdown(:user, user)
    end

    # this method is used to select a dictionary from dictionary drop-down on general role assignment page
    # @param: dictionary [String]
    def assign_dictionary(dictionary)
      select_dictionary.click
      assign_dictionary = dictionary.downcase
      select_from_dropdown(:dictionary, assign_dictionary)
    end

    # this method is used to select a segment from segment drop-down on general role assignment page
    # @param: segment [String]
    def assign_segment(segment)
      select_segment.click
      assign_segment = segment.downcase
      select_from_dropdown(:segment, assign_segment)
    end

    # this method is used to select a role from role drop-down on general role assignment page
    # @param: role [String]
    def assign_role(role)
      select_role.click
      assign_role = role.downcase
      select_from_dropdown(:role, assign_role)
    end


  end
end
