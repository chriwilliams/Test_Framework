require_relative 'sections'
require_relative 'crf_page'

module Rave
  class UserDetails < CrfPage
    section :header, Header, '.HeaderIconBar'

    element :cannot_save_inprod_checkbox, 'input[id$="CannotSaveInProductionChk"]'
    element :cannot_save_inprod_text, 'span[id$="CannotSaveInProductionReminderText"]'

    element :login_text, 'input[name$="LoginBox"]'
    element :pin_text, 'input[name$="PINBox"]'
    element :first_name_text, 'input[name$="FNameBox"]'
    element :last_name_text, 'input[name$="LNameBox"]'
    element :email_text, 'input[name$="EmailBox"]'
    element :trained_date_datapicker, 'input[id$="DatePickerTxt"]'
    element :training_sign_checkbox, 'input[id$="TrainSignedChk"]'
    element :language_dropdown, 'select[id$="LanguageDDL"]'
    element :user_details_update_btn, 'a[id$="TopSaveLnkBtn"]'
    element :training_update_btn, 'a[id$="btnTrainingUpdate"]'
    element :assign_to_study_button, 'a[id$="AssignStudyLnkBtn"]'
    element :select_role, 'select[id$="SelectRoleDDL"]'
    element :select_study, 'select[id$="ProjectDDL"]'
    element :assign_user, 'a[id$="AssignUserLnk"]'

    set_url_matcher /\/medidatarave\//i

    # Sets checkbox for 'Cannot Save in Production' flag to ON or OFF
    #@param state [string] state of check box. Valid input: checked, unchecked.
    def cannot_save_inprod_set(state)
      case state.downcase
        when 'checked'
          cannot_save_inprod_checkbox.set true
        when 'unchecked'
          cannot_save_inprod_checkbox.set false
        else
          raise "State: '#{state}' of the 'Cannot Save in Production' flag is not supported."
      end
    end
    #Verifies state of the checkbox for 'Cannot Save in Production' flag.
    #@param state [string] state of check box. Valid input: checked, unchecked.
    def cannot_save_inprod_verify(state)
      act_state = cannot_save_inprod_checkbox['checked'].to_s
      if (state.downcase == 'checked' and act_state.match(/(true)$/i)) or (state.downcase == 'unchecked' and act_state.empty?)
        print_to_output ("VERIFIED: 'Cannot Save in Production' is #{state} in Rave.")
      else
        raise "'Cannot Save in Production' is NOT #{state} in Rave."
      end
    end

    #Populates data in specified fields on User Details page
    #@param field [string] field name to populate with value (same as on UI)
    #@param value [string] value to populate
    def user_details_data_enter(field, value)
        case field.downcase
          when 'login', 'log in'
            login_text.set value
          when 'pin'
            pin_text.set value
          when  'first name'
            first_name_text.set value
          when 'last name'
            last_name_text.set value
          when 'email'
            email_text.set value
          when 'trained date'
            fill_date_picker('input[id$="DatePickerTxt"]', "#{value}")
          when 'training signed'
              training_sign_checkbox.set to_bool(value)
          when 'language'
            language_dropdown.set value
          when 'cannot save in production'
            cannot_save_inprod_set(value)
          else
            raise "Field: #{field} is not supported."
        end
    end

    #Clicks update button in specified section
    #@param section[string] section where we expect update button to be clicked.
    def user_details_save(section)
      case section.downcase
        when 'user details'
          user_details_update_btn.click
        when 'training'
          training_update_btn.click
        else
          raise "Section: #{section} is not supported."
      end
    end

    def select_assign_to_study
      assign_to_study_button.click
    end

    # selects study role on user details assign to study page
    def select_study_role(role)
      select_role.select role
    end

    # selects study on user details assign to study page
    def select_study(study)
      select_study.select study
    end

    def click_assign_user
      assign_user.click
    end

  end
end
