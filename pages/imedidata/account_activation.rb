require_relative '../common/base_page'

module Imedidata
  class AccountActivation < Common::BasePage

    element :useremail, 'input[id$=user_email]'
    element :username,  'input[id$=user_login]'
    element :firstname, 'input[id$=user_first_name]'
    element :lastname, 'input[id$=user_last_name]'
    element :sirname, 'input[id$=user_title]'

    element :middlename, 'input[id$=user_middle_name]'
    element :institution, 'input[id$=user_institution]'
    element :department, 'input[id$=user_department]'

    element :address1, 'input[id$=user_address_line_1]'
    element :address2, 'input[id$=user_address_line_2]'
    element :address3, 'input[id$=user_address_line_3]'
    element :city, 'input[id$=user_city]'
    element :postalcode, 'input[id$=user_postal_code]'
    element :countryname, 'select[id$=user_country]'
    element :timezone, 'select[id$=user_time_zone]'
    element :localization, 'select[id$=user_locale]'

    element :password, 'input[id$=user_password]'
    element :passwordconfirm, 'input[id$=user_password_confirmation]'
    element :pincode, 'input[id$=user_secondary_password]'

    element :homephone, 'input[id$=user_telephone]'
    element :mobilephone, 'input[id$=user_mobile]'
    element :fax, 'input[id$=user_fax]'
    element :pager, 'input[id$=user_pager]'
    element :newsletter, 'input[id$=user_receive_newsletter]'

    element :securityquestion, 'select[id$=user_user_security_question_attributes_security_question_id]'
    element :securityanswer, 'input[id$=user_user_security_question_attributes_answer]'

    element :submit, '#activation_user_link'
    element :error_message, '.error_messages' #TODO: Handle error messages ~MD

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # enters the user name.
    # @param name [String] the user name.
    def user_name_set(name)
      self.username.set name if nil_or_empty?(username[:value])
    end

    # enters the first name of the user.
    # @param name [String] the user's first name.
    def first_name_set(name)
      self.firstname.set name if nil_or_empty?(firstname[:value])
    end

    # enters the last name of the user.
    # @param name [String] the user's last name.
    def last_name_set(name)
      self.lastname.set name if nil_or_empty?(lastname[:value])
    end

    # enters the middle name or initial of the user.
    # @param name [String] the user's middle name or initial.
    def middle_name_set(name)
      self.middlename.set name
    end

    # enters the title of the user.
    # @param title [String] the user's title.
    def title_set(title)
      self.sirname.set title
    end

    # enters the email address of the user.
    # @param address [String] the user's email address.
    def email_set(address)
      self.email.set address
    end

    # enters the institution of the user.
    # @param name [String] the user's institution.
    def institution_set(name)
      self.institution.set name
    end

    # enters the department of the user.
    # @param dept [String] the user's department.
    def department_set(dept)
      self.department.set dept
    end

    # enters the address line 1 of the user.
    # @param address [String] the user's address.
    def address1_set(address)
      self.address1.set address
    end

    # enters the address line 2 of the user.
    # @param address [String] the user's address.
    def address2_set(address)
      self.address2.set address
    end

    # enters the address line 3 of the user.
    # @param address [String] the user's address.
    def address3_set(address)
      self.address3.set address
    end

    # enters the city of the user.
    # @param city [String] the user's city.
    def city_set(city)
      self.city.set city
    end

    # enters the postal code of the user.
    # @param code [String] the user's postal code.
    def postal_code_set(code)
      self.postalcode.set code
    end

    # selects the country of the user.
    # @param country [String] the user's country.
    def country_select(country)
      select(country, :from => countryname[:id])
    end

    # selects the address line 1 of the user.
    # @param zone [String] the user's address.
    def time_zone_select(zone)
      select(zone, :from => timezone[:id])
    end

    # selects the locale of the user.
    # @param locale [String] the user's locale.
    def locale_select(locale)
      select(locale, :from => localization[:id])
    end

    # enters and confirms the passwords of the user.
    # @param password [String] the user's password.
    def password_set(password)
      self.password.set password
      self.passwordconfirm.set password
    end

    # enters the PIN code of the user.
    # @param pin [String] the user's PIN code.
    def pin_code_set(pin)
      self.pincode.set pin
    end

    # enters the phone number of the user.
    # @param phone [String] the user's phone number.
    def phone_set(phone)
      self.homephone.set phone if nil_or_empty?(homephone[:value])
    end

    # enters the mobile phone number of the user.
    # @param phone [String] the user's mobile phone number.
    def mobile_set(phone)
      self.mobilephone.set phone
    end

    # enters the fax number of the user.
    # @param number [String] the user's fax number.
    def fax_set(number)
      self.fax.set number
    end

    # enters the pager number of the user.
    # @param number [String] the user's pager number.
    def pager_set(number)
      self.pager.set number
    end

    # selects the Site Email Newsletter checkbox.
    # @param enable [String] Whether or not to participate in newsletter email.
    def email_newsletter(enable=true)
      if enable
        check(self.newsletter)
      else
        uncheck(self.newsletter)
      end
    end

    # selects the security question and sets the answer of the user.
    # @param question [String] the security question.
    # @param answer [String] the user's answer.
    def security_question_enter(question, answer)
      select(question, :from => securityquestion[:id])
      self.securityanswer.set answer
    end

    # clicks the activate button.
    def activate
      submit.click
    end

    #returns User email from page
    def get_user_email
      useremail[:value]
    end

  end
end
