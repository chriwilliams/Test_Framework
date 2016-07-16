require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class ProjectRegistration < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :select_project,'select[id$="ddlProject"]'
    element :edit_project, 'a[id$="btnEditProject"]'
    element :add_icon, 'a[id$="LnkAddNewgridSegments"]'
    element :select_dictionary_name,  'input[id*="DXEditor0"]'
    elements :select_name_options, 'table[id$="DXEditor0_DDD_L_LBT"] > tbody > tr > td'
    element :select_dictionary_version, 'input[id*="DXEditor1"]'
    elements :select_version_options, 'table[id$="DXEditor1_DDD_L_LBT"] > tbody > tr > td'
    element :select_locale, 'input[id*="DXEditor2"]'
    elements :select_locale_options, 'table[id$="DXEditor2_DDD_L_LBT"] > tbody > tr > td'
    element :select_syn_list,  'input[id*="DXEditor3"]'
    elements :select_list_options, 'table[id$="DXEditor3_DDD_L_LBT"] > tbody > tr > td'
    element :save_dictionary, 'td.dxgvCommandColumn_Main_Theme.dxgv > img:nth-child(1)'
    element :save_and_send_to_source, 'a[id$="pnlSend_btnSaveSend"]'
    element :cancel_edit, 'a[id$="pnlSend_btnCancelEdit"]'
    element :send_ok, 'a[id$="pcSendWarning_btnSendOK"]'

    # registers a project with specific study, dictionary & version and a synonym list.
    # @param project[String]. Project to be registered with Rave.
    # @param dictionary [String]. A supported coder dictionary to be registered with rave.
    # @param version [String]. A supported coder dictionary version.
    # @param locale [String]. A supported coder dictionary locale; ENG/JPN.
    # @param syn_list [String]. An existing synonym list which is created previously coming to this step.
    def register_project(project, dictionary, version, locale, syn_list)
      select_project.select project
      edit_project.click
      add_icon.click
      select_dictionary_name.click
      select_from_dropdown(:dictionary_name, dictionary)
      select_dictionary_version.click
      select_from_dropdown(:version, version)
      select_locale.click
      select_from_dropdown(:locale, locale)
      select_syn_list.click
      select_from_dropdown(:synonym_list, syn_list)
      save_dictionary.click
      sleep 10
      save_and_send_to_source.click
      send_ok.click
    end


    private

    # helper method to select a value from drop-down based on the given field.
    # @param field [Object]. Drop-down field is an element defined in this class according to site_prism  standard.
    # @param value [String]. Value to be selected from the list of options in the passed in 'field'
    def select_from_dropdown(field, value)
      sleep 3
      found_value = case field
                      when :dictionary_name
                        select_name_options.detect { |item| item.text.downcase.include? value.downcase }
                      when :version
                        select_version_options.detect { |item| item.text.include? value }
                      when :locale
                        select_locale_options.detect { |item| item.text.downcase.include? value.downcase }
                      when :synonym_list
                        select_list_options.detect { |item| item.text.downcase.include? value.downcase }
                      else
                        raise 'Please provide valid input'
                    end

      raise "Value #{value} for field #{field.to_s} not found" unless found_value
      found_value.click
      sleep 5
    end

  end

end