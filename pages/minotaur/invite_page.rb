require_relative '../common/base_page'

module Minotaur
  class InvitePage < Common::BasePage

    set_url $config['ui']['apps']['patient_management']['base_url']

    element :subject, '#patient_enrollment_subject'
    element :country_language, '#patient_enrollment_country_language'
    element :email, '#patient_enrollment_email'
    element :initials, '#patient_enrollment_initials'
    element :invite_button, '#invite-button'
    element :activation_code_value, '#patient-list tr:nth-of-type(1) td:nth-of-type(5)'
    element :study_value, '#patient_management_study > option:nth-child(2)'
    element :study_site, '#patient_management_study_site > option:nth-child(2)'
    element :study_site_select, '#patient_management_study_site'
    element :study_to_select, 'select#user_user_security_question_attributes_security_question_id'
    element :launch_button, '#launch-patient-management'
    element :session_username, '#session_username'
    element :session_password, '#session_password'
    element :login_button, '#create_session_link'
    element :patient_management_study_site, 'select#patient_management_study_site'
    element :patient_management_study, 'select#patient_management_study'
    element :patient_enrollment_subject, 'select#patient_enrollment_subject'
    element :patient_enrollment_initials, '#patient_enrollment_initials'
    element :activation_code_from_grid, '#patient-list tr:nth-of-type(1) td:nth-of-type(5)'
    element :select_first_study, '#patient_management_study > option:nth-child(2)'
    element :logout_link, '#logout'
    element :user_name, '#user.btn-group a[data-toggle="dropdown"]'

    def initialize
      self.load
    end

    def logout
      user_name.click
      logout_link.click
    end

    def get_previous_activation_code
      @activation_code_old = activation_code_from_grid.text
    end

    def validate_invite(new_activation_code)
      if @activation_code_old == new_activation_code
        fail!(raise(ArgumentError.new('Activation Code geenration error!')))
      end
    end

    def select_study(study_name="")
      if study_name.eql?("")
        select_first_study.click
      else
        select(study_name, :from => patient_management_study[:id])
      end
    end

    def select_site(study_site_name="")
      if study_site_name.eql?("")
        find(study_site).click
      else
        select(study_site_name, :from => patient_management_study_site[:id])
      end
    end

    def select_subject(subject_name)
      select(subject_name, :from => patient_enrollment_subject[:id])
    end

    def select_country_language
      select("Canada / English", :from => country_language[:id])
    end

    def set_initials
      patient_enrollment_initials.set "A.D"
    end

    def wait_for_field
      sleep 2
    end

    def enter_user_name(username)
      self.session_username.set username
    end

    def enter_password(password)
      self.session_password.set password
    end

    def get_activation_code
      activation_code_from_grid.text
    end

    def check_subject_initials_empty
      (patient_enrollment_subject.value.empty? && patient_enrollment_initials.text.empty?)
    end
  end
end
