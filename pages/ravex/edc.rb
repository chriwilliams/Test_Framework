require_relative '../common/base_page'
require_relative 'sections'

module Ravex
  class Edc < Common::BasePage
    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'
    section :subject_header, SubjectHeader, 'div[class="page-header page-header-main clearfix"]'
    section :subject_menu_nav, SubjectMenuNav, '#left-rail'
    section :crf_version, CrfVersion, 'p[class="text-muted"] > small'

    elements :fields, 'div[class*="edcRow"]'
    element :form_name, 'div[class^="ecrf-form-header"]'
    element :save_button, 'button[type="submit"]'
    element :cancel_button, 'a#cancel'
    element :modal, 'div[class=modal-dialog]'
    element :sign_form, 'a#sign-button'

    set_url_matcher /.checkmate./

    attr_reader :field

    # enters data on a standard form for RaveX EDC
    # @param label [string] the field name
    # @param type [string] the control type of the field
    # @param value [string] the value to enter into the field
    def form_data_enter(label, type, value = nil)
      field_detect(label)

      case type.to_s.downcase
        when 'text'
          text_field_enter(value)
        when 'long_text'
          long_text_field_enter(value)
        when 'drop_down'
          drop_down_field_select(value)
        when 'date'
          date_field_enter(value)
        when 'check_box'
          check_box_field_select(value)
        when 'radio_button'
          radio_button_field_select(value)
        when 'search_list'
          search_list_field_enter(value)
        when 'dynamic_search_list'
          d_search_list_field_enter(value)
        when 'file_upload'
          file_upload_to_field(value)
        else
          raise "Invalid or Unsupported field type '#{type}'"
      end
    end

    # saves the form
    def form_save
      save_button.click
    end

    # cancels the form
    def form_cancel
      cancel_button.click
    end

    # Clicks on specified actions for the specified data field.
    # @param label [string] is label of the data field to perform action.
    # @param action [string] is action to perform.
    def data_field_action_select(label, action)
      field_detect(label)
      @field.all(:css, 'button[data-toggle="dropdown"]').first.click #opens the actions menu
      action_list = @field.all(:css, 'ul[class="dropdown-menu pull-right"] > li > a')
      action_item = action_list.detect { |item| item.text == action }

      if action_item
        action_item.click
      else
        raise "Action: #{action} is not available for the field: #{label}."
      end
    end

    # Opens query to specified marking group with specified text and require_response for specified field.
    # @param label [string] name of field
    # @param marking_group [string] name of marking group
    # @param require_response [boolean] state of require response checkbox.
    def query_sticky_data_enter(label, marking_group = nil, text = nil, require_response = nil)
      field_detect(label)

      marking_group_field = @field.all(:css, 'select[id $="SelectedMarkingGroup"]').first
      raise "Marking group dropdown not found for the field: '#{label}'." unless marking_group_field

      text_field = @field.all(:css, 'textarea[id $="MarkingText"]').first
      raise "Text field not found for the field: '#{label}'." unless text_field

      marking_group_field.select marking_group if marking_group
      text_field.set text if text_field

      if require_response
        req_response = @field.all(:css, 'input[id $="RequiresResponse"]').first
        raise "Requires Response checkbox not found for the field: '#{label}'." unless req_response
        req_response.set !!require_response # Set marking group if it's required.
      end
    end

    # Verifies specified icon for specified field.
    # @param label [string] name of the field
    # @param icon_name [string] name of the icon to be verified.
    def field_icon_verify(label, icon_name)
      field_icons = { 'Complete' => 'i[class="edc-icon edc-icon-dp-ok"]',
                     'Never Touched' => 'i[class="edc-icon edc-icon-dp-bl"]',
                     'Locked' => 'i[class="edc-icon edc-icon-dp-lo"]',
                     'Entry Lock' => 'i[class="edc-icon edc-icon-dp-fr"]',
                     'Not Conformant' => 'i[class="edc-icon edc-icon-dp-nc"]',
                     'Inactive' => 'i[class="edc-icon edc-icon-dp-ia"]',
                     'Overdue' => 'i[class="edc-icon edc-icon-dp-od"]',
                     'Incomplete' => 'i[class="edc-icon edc-icon-dp-pc"]',
                     'Requires Verification' => 'i[class="edc-icon edc-icon-dp-ru"]',
                     'Requires Review' => 'i[class="edc-icon edc-icon-dp-rr"]',
                     'Query Open' => 'i[class="edc-icon edc-icon-dp-oq"]',
                     'Answered Query' => 'i[class="edc-icon edc-icon-dp-aq"]',
                     'Requires Coding' => 'i[class="edc-icon edc-icon-dp-rc"]',
                     'Requires Signature' => 'i[class="edc-icon edc-icon-dp-sg"]' }
      icon = field_icons[icon_name]

      field_detect(label)

      icon_image = @field.all(:css, icon).first
      if icon_image
        print_to_output("VERIFIED: Expected icon: '#{icon_name}' is displayed for the field '#{label}'.")
      else
        raise "Expected icon: '#{icon_name}' is NOT displayed for the field '#{label}'."
      end
    end

    # returns a value for a certain field in RaveX EDC
    # @param label [string] the field name
    # @return [array] the value of the field
    def get_field_value(label)
      field_detect(label)
      element = @field.all(:css, 'div[class*="clearfix data-column"]').first
      element.all(:css, 'span[class^="read edit"]').each do |entry|
        entry.text
      end
    end

    # signs the current form on the page
    # @param user_name [string] the user name to sign the eCRF
    # @param password [string] the password of the user
    def form_sign(user_name, password)
      sign_form.click
      form_sign_data_enter(user_name, password)
    end

    # selects the Audit link for the field
    # @param label [string] the field name
    def audit_select(label)
      field_detect(label)
      element = @field.all(:css, 'a[data-target="#audits-modal"]').first
      element.click
    end

    # verifies the Audit data
    # @param a_data [array] the Audit data array to verify against
    # @param v_data [string] the data you are trying to verify
    def audit_data_verify(a_data, v_data)
      found = nil
      a_data.each do |entry|
        if entry.text.match(v_data)
          found = true
          print_to_output("VERIFIED: Expected Audit data: '#{v_data}' is displayed.")
          break
        end
      end
      raise "Audit data #{v_data} was not found!" unless found
    end

    # gets the entries in the Audit table
    # @return [array] the values of each row in the Audit table
    def audit_data_get
      table = modal.find('table[class^="audit-table"]')
      table.all(:css, 'tr').each do |element|
        element.all(:css, 'td').each do |entry|
          entry.text
        end
      end
    end

    # close a modal
    def close_modal()
      button = find('.modal-dialog button.close')
      button.click
    end

    protected

    # detects field label on a RaveX EDC form
    # @param label [string] the field name
    def field_detect(label)
      @field = fields.detect { |item| item.text.include? label }

      raise "Field '#{label}' was not found on form." unless @field
    end

    # enters and submits the user name and password into the eSignature form
    # @param user_name [string] the user name to sign the eCRF
    # @param password [string] the password of the user
    def form_sign_data_enter(user_name, password)
     frame = modal.find('iframe[class=signature-iframe]')
        within_frame(frame) {
          user = find('input[id=username]')
          user.set "#{user_name}"
          pass = find('input[id=password]')
          pass.set "#{password}"
          e_sign = find('button[type="submit"]')
          e_sign.click
        }
    end

    private

    # enters data into a text field
    # @param value [string] the value to enter into the text box
    def text_field_enter(value)
      control = @field.all(:css, 'input[type="text"]').first
      control.set "#{value}"
    end

    # enters data into a long text field
    # @param value [string] the value to enter into the long text box
    def long_text_field_enter(value)
      control = @field.all(:css, 'textarea[class="form-control"]').first
      control.set "#{value}"
    end

    # selects option from a drop down field type
    # @param value [string] the value to select from the drop down
    def drop_down_field_select(value)
      control = @field.all(:css, 'select[class="form-control"]').first[:id]
      select(value, :from => control)
    end

    # enters data in a date field type. supports dd-MMM-yyyy format only
    # @param date [string] the date value to select and populate for a date field
    def date_field_enter(date)
      my_date = Date.parse(date)
      year = my_date.year
      month = my_date.strftime('%b')
      day = my_date.strftime('%d')

      day_field = @field.all(:css, 'input[id$="DayValue"]').first
      day_field.set "#{day}"

      month_drop_down = @field.all(:css, 'select[id$="MonthLongValue"]').first[:id]
      select(month, :from => month_drop_down)

      year_field = @field.all(:css, 'input[id$="YearValue"]').first
      year_field.set "#{year}"
    end

    # checks or un-checks a check box field
    # @param value [string] true or false on whether or not you want to check or un-check the field
    def check_box_field_select(value)
      control = @field.all(:css, 'input[type="checkbox"][id$="__Data"]').first[:id]
      if value.to_s.downcase == 'true'
        check(control)
      else
        uncheck(control)
      end
    end

    # selects a radio button for the field
    # @param value [string] the label of the radio button you want to select
    def radio_button_field_select(value)
      @field.all(:css, 'span[class="radio-option-item"]').each do | name |
        if name.text.downcase == value.to_s.downcase
          control = name.all(:css, 'input[type="radio"]').first
          control.set true
          break
        end
      end
    end

    # filters text and then selects from a search list field. If no filter is provided, the arrow is selected.
    # @param value [string] the value to select and/or filter for the search list field in colon delimited format.
    def search_list_field_enter(value)
      value_arr = value.chomp.split(':')
      text_field = ''
      s_filter = ''

      if value_arr.size > 0 # type in the field if filter is provided
        s_filter = value_arr.first
        text_field = @field.all(:css, 'input[type="text"][searchlist="True"]').first[:id]
      else
        control = @field.all(:css, 'i[class$="open-search-list"]').first
        control.click
      end

      s_value = value_arr.last

      fill_auto_complete(text_field, s_filter, s_value)
    end

    # filters text and then selects from a dynamic search list field. If no filter is provided, the arrow is selected.
    # @param value [string] the value to select and/or filter for the dynamic search list field in colon delimited format.
    def d_search_list_field_enter(value)
      value_arr = value.chomp.split(':')
      text_field_id = ''
      s_filter = ''

      if value_arr.size > 0 # type in the field if filter is provided
        s_filter = value_arr.first

        text_field = @field.all(:css, 'input[type="text"][class*="dynamic-search-list"]').first
        raise 'Dynamic Searchlist field not found' unless text_field

        text_field_id = text_field[:id]
        text_field.set s_filter
        sleep 5
      else
        control = @field.all(:css, 'i[class$="open-dynamic-search-list"]').first
        control.click
        sleep 5
      end

      s_value = value_arr.last

      fill_auto_complete(text_field_id, s_filter, s_value)
    end

    # uploads a file to a certain field
    # @param file_path [string] the path and file name you want to upload
    def file_upload_to_field(file_path)
      control = @field.all(:css, 'input[type="file"]').first[:id]
      upload_file(control, file_path)
    end

    # handles JQuery Autocomplete widget
    # @param field [string] the CSS id of the field
    # @param filter [string] the partial text you want to enter into the field to bring up the drop down list
    # @param full_text [string] the text you want to select from the field
    def fill_auto_complete(field, filter = nil, full_text)
      fill_in field, with: filter unless filter

      page.execute_script %Q{ $('##{field}').trigger('focus') }
      page.execute_script %Q{ $('##{field}').trigger('keydown') }

      selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{full_text}")}

      sleep 5
      page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
      sleep 5
    end

  end
end
