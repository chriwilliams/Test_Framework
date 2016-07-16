require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Forms < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'
    section :navigation_tabs, NavigationTabs, 'table[id$="PgHeader_TabTable"]'
    element :forms_table, 'table[id$="FormGrid"]'
    element :form_filter, 'input[id$="Content_TextBoxFilter"]'
    element :search_link, 'a[id$="Content_LnkBtnSearch"]'
    element :add_link, 'a[id$="InsertForm"]'
    element :enter_form_name, 'input[id$="Name"]'
    element :enter_form_oid, 'input[id$="txtOID"]'
    element :add_new, 'a[id*="LnkBtnInsertField"]'
    element :variable_oid, 'input[id="VC_txtOID"]'
    element :format, 'input[id="VC_txtFormat"]'
    element :field_name, 'input[id*="txtFieldName"]'
    element :field_oid, 'input[id*="txtFieldOID"]'
    element :label,  'textarea[id="txtFieldLabel"]'
    elements :save_form, 'a[id*="LnkBtnSave"]'
    element :drop_down, 'select[id$="ddlInsertForm"]'

    attr_reader :form

    # Opens fields of a form.
    # @param form_name [string] name of the form to open
    def form_fields_open(form_name)
      form_detect(form_name)
      element = @form.find(:css, 'a[id$="FormDesignerLnk"]')
      element.click
    end

    # executes a search for the desired form
    # @param form_name [string] the form name you want to search for
    def form_search(form_name)
      form_filter.set "#{form_name}"
      search_link.click
    end

    # adds form to selected location
    # @param location [String] the location to where you want the form
    def form_add_to_location(location)
      page.execute_script "window.scrollBy(0,10000)"
      wait_for_add_link
      add_link.click
      wait_for_drop_down
      drop_down.select location
    end

    # adds a form at the desired location
    # @param location [String] the location to where you want the form
    # @param form_name [String] name of form
    # @param form_oid [String] oid for the form
    def add_form(location, form_name, form_oid)
      form_add_to_location location
      enter_form_name.set form_name
      enter_form_oid.set form_oid
      page.find_link('Update').click
    end


    # sets values in the necessary form fields and then saves the form
    # @param var_oid [String] a unique oid for the variable
    # @param use_format [String] number of characters allowed or any other data type allowed for the field
    # @param  form_field_name [String] name for the field in the form
    # @param  form_field_oid [String] oid for the field
    # @param  form_field_label [String] label for the field inside the form
    def configure_form(var_oid, use_format, form_field_name, form_field_oid, form_field_label)
      wait_for_add_new
      add_new.click
      wait_for_variable_oid
      variable_oid.set var_oid
      format.set use_format
      field_name.set form_field_name
      field_oid.set form_field_oid
      label.set form_field_label
      save_form.first.click
    end


    private

    # detects the form row on the Forms page
    # @param form_name [string] the form name you want to perform the action on.
    def form_detect(form_name)
      forms_table.all(:css, 'tr[class$="Row"]').each do | entry |
        element = entry.find(:css, 'span[id$="DispName"]')
        if element.text.to_s.downcase == form_name.to_s.downcase
          @form = entry
          break
        end
      end
      raise "Form #{form_name} not found." unless @form
    end

  end
end