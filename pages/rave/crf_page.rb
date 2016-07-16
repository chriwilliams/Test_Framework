require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class CrfPage < Common::BasePage
    section :header, Header, 'td[class^="HeaderIconBar"]'
    section :navigation_tabs, NavigationTabs, 'table[id$="PgHeader_TabTable"]'
    section :menu_nav, SubjectMenuNav, 'table[id$="LeftNav_EDCTaskList_TblOuter"]'

    elements :data_tables, 'table[class="crf_dataPointInternal"]'
    element :nav_table, 'table[id$="LeftNav_EDCTaskList_TblTaskItems"]'
    element :log_table, 'table[id$="log"]'
    elements :coder_tables, 'td[class="crf_datapointInternalCell"]'
    elements :all_rows, 'table[class$="Row"]'
    elements :all_warning_rows, 'table[class$="Warning"]'
    element :save_button, 'input[id$="footer_SB"]'
    element :sign_and_save_button, 'button#SignAndSaveButton'
    element :cancel_button, 'input[id$="footer_CB"]'
    element :cannot_save_in_prod_table_text, '#CannotSaveInProductionReminderTable'
    elements :form_name, 'span[id$="Content_R"] > table > tbody > tr > td[align="left"]'

    attr_reader :field

    set_url_matcher /\/MedidataRave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # verifies coded terms on the crf
    # @param data [array] array of values to verify on the page.
    def data_verify(data)
      data_table = data_tables.detect { |item| item.text.downcase.include? data[0].value.downcase }
      data.each do |element|
        raise 'Data does not match: ' + "#{data_table.text.downcase} does NOT include #{element.value.to_s.downcase}" unless data_table.text.downcase.include? element.value.to_s.downcase
      end
    end

    # opens a logline in the logtable
    # @param link_name [string] name of the link to click
    # @param line_num [number] line number of the logtable
    # @param is_coder [Boolean] whether or not this is a coder specific log line
    def log_line_open(link_name, line_num, is_coder = nil)

      rows = log_table.all('tr')
      line_num = (line_num.to_i) * 2
      exists = rows[line_num].text.include? link_name
      if exists
        rows[line_num].find_link(link_name).click
      else
        raise "link #{link_name} not found at Log Line #{line_num}"
      end

      # code to wait for the text to appear
      if is_coder
        end_time = Time.now + 1800
        while coder_tables.count <= 1 && Time.now < end_time do
          refresh_browser
          sleep 30
        end
        raise 'Coding terms not found on the page even after 30 minutes' unless coder_tables.count > 1
      end
    end

    # enters data on a standard form for Rave EDC
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
        else
          raise "Invalid or Unsupported field type '#{type}'"
      end
    end

    # Clicks the Save button on crf page
    def form_save
      save_button.click
    end

    # Clicks the Cancel button on crf page
    def form_cancel
      cancel_button.click
    end

    # adds a log line to a log or mixed form
    def log_line_add
      add_link = log_table.all(:css, 'a[id$="log_log_AddLine"]').first
      add_link.click
    end

    # Verifies query text on Rave EDC form for the specified field.
    # @param field [string] the field name
    def query_text_get(field)
      field_detect(field)
      all_query_field = @field.all(:css, 'td[class=crf_preText] > table > tbody > tr ')
      query_date_details_field = @field.all(:css, 'td[class=crf_preText] > table > tbody > tr > td > font')
      query_text_actual = all_query_field.first.text #.gsub(query_date_details_field.first.text,'').strip #need it to match query text exactly
    end

    # Verified specified icon for specified field.
    # @param label [string] name of the field
    # @param icon_name [string] name of the icon to be verified.
    def field_icon_verify(label, icon_name)
      field_icons = {'Complete' => 'img[src$="dp_ok.gif"]',
                     'Never Touched' => 'img[src$="dp_bl.gif"]',
                     'Locked' => 'img[src$="dp_lo.gif"]',
                     'Entry Lock' => 'img[src$="dp_fr.gif"]',
                     'Not Conformant' => 'img[src$="dp_nc.gif"]',
                     'Inactive' => 'img[src$="dp_ia.gif"]',
                     'Overdue' => 'img[src$="dp_od.gif"]',
                     'Incomplete' => 'img[src$="dp_pc.gif"]',
                     'Requires Verification' => 'img[src$="dp_ru.gif"]',
                     'Requires Review' => 'img[src$="dp_rr.gif"]',
                     'Query Open' => 'img[src$="dp_oq.gif"]',
                     'Answered Query' => 'img[src$="dp_aq.gif"]',
                     'Requires Coding' => 'img[src$="dp_rc.gif"]',
                     'Requires Signature' => 'img[src$="dp_sg.gif"]'}
      icon = field_icons[icon_name]

      field_detect(label)

      icon_image = @field.all(:css, icon).first
      if icon_image
        print_to_output("VERIFIED: Expected icon: '#{icon_name}' is displayed for the field '#{label}'.")
      else
        raise "Expected icon: '#{icon_name}' is NOT displayed for the field '#{label}'."
      end
    end

    # Verifies if "Save" or "Sign and Save" button is disabled on page
    #@param button_text[string] button text: "Save" or "Sign and Save"
    def save_button_disabled_verify(button_text)
      case button_text.to_s.downcase
        when 'save'
          if save_button['disabled'].match(/(true)$/i)
            print_to_output('VERIFIED: "Save" button is disabled.')
          else
            raise 'Save button is active.'
          end
        when 'sign and save'
          if sign_and_save_button['disabled'].match(/(true)$/i)
            print_to_output('VERIFIED: "Sign and Save" button is disabled.')
          else
            raise 'Save button is active.'
          end
      end
    end

    #Verifies if "Saving is disabled." sign in available on the top of the page.
    def cannot_save_in_prod_sign_verify()
      if cannot_save_in_prod_label
        print_to_output('VERIFIED: "Saving is disabled." sign is available on EDC page.')
      else
        raise '"Saving is disabled." sign is NOT available on the page.'
      end
    end

    #Gets value of the specified field on EDC forms.
    #@param label [string] label
    def get_field_value(label)
      field_detect(label)
      data_field = @field.all(:css, 'td[class="crf_datapointInternalCell"]').first
      data_field.text
    end

    #Enters data in data format in the field with data picker
    #@param id [string] css id of the field
    #@param value [string] value to populate field with
    def fill_date_picker(id, value)
      datapicker = find_all("#{id}")
      raise "Element: #{id} is not available on the page." unless datapicker
      page.execute_script %Q{ $('#{id}').val('#{value}') }
    end

    # verifies if a coded term appears on the crf page
    # it will error out after 16mins if the text is not found.
    def wait_for_data_to_verify(data)
      data_table = data_tables.detect { |item| item.text.downcase.include? data[0].value.downcase }
      try = 0
      begin
        data.each do |element|
          sleep 16
          value_to_check_against = data_table.text.downcase
          expected_value = element.value.to_s.downcase
          raise "not matching" if !value_to_check_against.include?(expected_value)
        end
        print_to_output('Coded term is on CRF Page')
      rescue
        try = try + 1
        refresh_browser
        retry if try < 60
        raise "Expected data found after 16 mins"
      end
    end

    protected

    # Detects field label on a Rave EDC form
    # @param label [string] the field name
    def field_detect(label)
      if all_rows.find { |item| item.text.include? label }
        @field = all_rows.find { |item| item.text.include? label }
      elsif all_warning_rows.find { |item| item.text.include? label }
        @field = all_warning_rows.find { |item| item.text.include? label }
      end

      raise "Field '#{label}' was not found on form." unless @field
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
      control = @field.all(:css, 'textarea[id*="CRFControl_Text"]').first
      control.set "#{value}"
    end

  end
end
