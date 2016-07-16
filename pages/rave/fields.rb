require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Fields < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'
    section :navigation_tabs, NavigationTabs, 'table[id$="PgHeader_TabTable"]'
    element :fields_table,  'table[id$="FieldsGrid"]'
    element :coder_dict_list,  'select[id$="ddlCodingDictionary"]'
    element :coder_nav_button, 'input[id="BtnCoderAdvanced"]'
    element :save_link, 'a[id$="LnkBtnSave"]'
    element :cancel_link, 'a[id$="LnkBtnCancel"]'

    attr_reader :field

    # Opens a field for edit.
    # @param field_name [string] name of the field to edit
    def field_edit(field_name)
      field_detect(field_name)
      element = @field.find(:css, 'input[id$="ImgBtnSelect"]')
      element.click
    end

    # selects dictionary from the list of dictionaries
    # @param dict_name [string] dictionary to select
    def coder_dict_select(dict_name)
      coder_dict_list.select(dict_name)
    end

    # Navigates to coder config
    def coder_config_nav
      coder_nav_button.click
    end

    # saves the fields page
    def fields_save
      save_link.click
    end

    # cancels the fields page
    def fields_cancel
      cancel_link.click
    end

    private

    # detects the field row on the Fields page
    # @param field_name [string] the field name you want to perform the action on.
    def field_detect(field_name)
      fields_table.all(:css, 'tr[class$="Row"]').each do | entry |
        element = entry.find(:css, 'span[id$="DispFieldName"]')
        if element.text.to_s.downcase == field_name.to_s.downcase
          @field = entry
          break
        end
      end
      raise "Field #{field_name} not found." unless @field
    end

  end
end
