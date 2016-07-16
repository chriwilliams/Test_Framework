require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class CoderConfiguration < Common::BasePage

    element :save_button, 'a[id$="LnkBtnTopSave"]'
    element :coder_marking_group_select, 'select[id$="coderMarkingGroup"]'
    element :require_response_checkbox, 'input[id$="chkReqResponse"]'
    element :coding_level_list, 'select[id$="LevelDDL"]'
    element :save_btn, 'input[id$="BtnSave"]'
    element :supp_list, 'select[id$="SuppDDL"]'
    element :comp_name_list, 'select[id$="CompDDL"]'
    element :comp_value_list, 'select[id$="ComponentDDL"]'
    element :add_supp_btn, 'input[id$="BtnAddSupplemental"]'
    element :add_comp_btn, 'input[id$="BtnAddComponent"]'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def coder_cofigurations_set(coder_marking_group, require_response)
      coder_marking_group_select.select coder_marking_group
      require_response_checkbox.set require_response
      save_button.click
    end

    # selects coding level from the list of dictionaries
    # @param coding_level [string] coding level to select
    def coding_level_select(coding_level)
      coding_level_list.select(coding_level)
    end

    # saves coder config page
    def coder_config_save
      save_btn.click
    end

    # selects and saves supplemental fields on rave coder configuration page
    # @param supp_fields [hash] it holds all the values for the fields to select
    def select_supp_fields(supp_fields)
      supp_fields.each do |supp_field|
        supp_list.select supp_field.value
        add_supp_btn.click
      end
    end

    # selects and saves component fields on rave coder configuration page
    # @param comp_name [string] component field name to select
    # @param comp_value [string] component field value to select
    def select_comp_fields(comp_name,comp_value)
        comp_name_list.select comp_name
        comp_value_list.select comp_value
        add_comp_btn.click
    end
  end
end