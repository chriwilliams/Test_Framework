require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class AssignTreatments < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    elements :treatment_rule_headers, '#treatment_rules_header label' #collection labels
    elements :treatment_rule_multiselects, '#treatment_rules_header button' #collection multiselects
    elements :multi_select_all, 'div.ui-multiselect-menu a.ui-multiselect-all' #collection links
    elements :multi_select_none, 'div.ui-multiselect-menu a.ui-multiselect-none' #collection links
    elements :multi_select_labels, 'div.ui-multiselect-menu label' #collection labels
    elements :label_checkboxes, 'div.ui-multiselect-menu label input' #collection checkboxes

    elements :treatment_names, '.treatment_name' #collection labels
    elements :treatment_cell, '#treatments td:nth-child(2)' #collection links

    element :toggle_all, '#toggle_all' #checkbox

    # Filters treatment rules
    # @param filter_table [table] table of treatment rules
    def filter_treatment_rules(filter_table)
      filter_table.raw.each do |row|
        treatment_rule_headers.each_with_index do |header,index|
          if header.text == row[0]
            treatment_rule_multiselects[index].click
            multi_select_none[0].click
            options = row[1].split(',')
            options.each do |option|
              if option == "None"
                multi_select_none[0].click
              elsif option == "All"
                multi_select_all[0].click
              else
                checkbox_index = get_element_index(multi_select_labels, option)
                label_checkboxes[checkbox_index].set(true)
              end
            end
            treatment_rule_multiselects[index].click
          end
        end
      end
    end

    # Assigns treatment to provided rules
    # @param treatment_name [string] the name of the treatment to assign
    # @param filter [table] table of treatment rules
    def assign_treatment(treatment_name,filter)
      filter_treatment_rules(filter)
      toggle_all.set(true)
      index = get_element_index(treatment_names, treatment_name)
      treatment_names[index].click
    end

  end
end