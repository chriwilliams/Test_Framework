require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class TreatmentDesign < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :article_types_table, Table, '#article_types'
    section :treatment_compostions_table, Table, '#treatments'
    section :dosing_factors_table, Table, '#dosing_factors'

    # article type elements
    element :add_article_type, '#article_types_add_button' #button
    elements :article_types, '#article_types a' #collection links
    element :modal_article_type_name, '#modal #article_type_name' #button
    element :modal_article_type_components, '#modal #article_type_contains_components' #checkbox
    elements :modal_at_component_fields, '#components input[type=text]' #collection text fields
    element :modal_add_component, '#modal #add_component' #button
    element :modal_article_type_unnumbered, '#modal #article_type_is_unnumbered' #checkbox
    element :modal_article_type_open_label, '#modal #article_type_is_open_label' #checkbox
    element :modal_article_type_save, '#modal #save_article_type' #button
    element :modal_article_type_cancel, '#modal #cancel' #button
    element :modal_article_type_delete, '#modal #delete' #button
    element :modal_article_type_internal_id, '#article_type_internal_inventory_identifier' #text field

    # treatment elements
    element :add_treatment, '#treatments_add_treatment_button' #button
    elements :treatments, '#treatments a' #collection links
    element :modal_treatment_name, '#modal #treatment_name' #text field
    element :modal_treatment_dnd, '#modal #treatment_do_not_dispense' #text field
    element :modal_treatment_add_article_type, '#modal #add_article_type' #button
    elements :modal_treatment_at_dropdowns, '#modal #treatment_article_types select' #collection dropdowns
    elements :modal_treatment_at_counts, '#modal #treatment_article_types input[type=text]' #collection text fields
    element :modal_treatment_save, '#modal #save_button' #button
    element :modal_treatment_cancel, '#modal #cancel' #button
    element :modal_treatment_delete, "#modal button[data-method='delete']" #button

    # dosing factor elements
    element :add_factor, '#add_factor' #button
    elements :dosing_factors, '#dosing_factors a' #collection links

    # titration elements
    element :enable, '#enable_tit_button' #button
    element :disable, '#disable_tit_button' #button
    element :add_level_set, '#titration_add_level_set_button' #button
    element :up_titrate_checkbox, '#study_design_enable_disallow_up_titration_after_number_downs' #checkbox
    element :up_titrate_limit, '#study_design_disallow_up_titration_after_number_downs' #text field
    element :down_titrate_checkbox, '#study_design_enable_disallow_down_titration_after_number_ups' #checkbox
    element :down_titrate_limit, '#study_design_disallow_down_titration_after_number_ups' #text field
    element :all_titrate_checkbox, '#study_design_enable_disallow_titration_after_number_up_or_down' #checkbox
    element :all_titrate_limit, '#study_design_disallow_titration_after_number_up_or_down' #text field
    element :maintin_counted, '#study_design_maintain_acts_as_up_or_down_titration' #checkbox
    element :single_step, '#study_design_max_titration_step_amount' #checkbox
    element :limit_reached_maintain, '#study_design_titration_rule_violation_1' #radio button
    element :limit_reached_error, '#study_design_titration_rule_violation_2'

    # Clicks on the given article type in the article type table
    # @param article [string] article type name
    def select_article_type(article)
      index = get_element_index(article_types, article)
      article_types[index].click
    end

    # Clicks on the given treatment in the treatments table
    # @param treatment [string] treatment name
    def select_treatment(treatment)
      index = get_element_index(treatments, treatment)
      treatments[index].click
    end

    # Clicks on the given dosing factor in the dosing factors table
    # @param dosing_factor [string] dosing factor name
    def select_dosing_factor(dosing_factor)
      index = get_element_index(dosing_factors, dosing_factor)
      dosing_factors[index].click
    end

    # Inputs the article components in the article type edit modal
    # If more than 2 are passed, the add component button is clicked to
    # add more text fields and the components are set.
    # @param all_components [string] article type components delimited by ','
    def input_article_type_components(all_components)
      modal_article_type_components.click
      components = all_components.split(',')
      for i in 0..components.size()-1
        modal_add_component.click if i > 1
        modal_at_component_fields[i].set components[i]
      end
    end

    # Adds an article type
    # @param table [table] table of article type options
    def add_new_article_type(table)
      input = table.rows_hash
      add_article_type.click
      modal_article_type_name.set input['Name']
      input_article_type_components(input['Components']) if input.has_key?('Components')
      if input.has_key?('Unnumbered')
        modal_article_type_unnumbered.click if input['Unnumbered']=='Yes'
        if input.has_key?('Open Label')
          modal_article_type_open_label.click if input['Open Label']=='Yes'
        end
      end
      modal_article_type_internal_id.set input['Internal inventory ID'] if input.has_key?('Internal Inventory ID')
      modal_article_type_save.click
    end

    # Adds a treatment
    # @param name [string] name of treatment
    # @param dnd [string] do not dose of treatment
    # @param composition [string] composition of string
    # delemit multiple article compositions by ','
    # eg) 1XFixitol,2XPlacebo
    def add_new_treatment(name, dnd, composition)
      add_treatment.click
      modal_treatment_name.set name
      modal_treatment_dnd.set dnd
      composition_pairs = composition.split(',')
      composition_pairs.each_with_index { |pair, index|
        article_value = pair.split('X')
        modal_treatment_add_article_type.click if index > 1
        modal_treatment_at_dropdowns[index].select article_value[1]
        modal_treatment_at_counts[index].set article_value[0]
      }
      modal_treatment_save.click
    end

    # Deletes an article type
    # @param article_name [string] the name of the article type
    def delete_article_type(article_name)
      select_article_type(article_name)
      modal_article_type_delete.click
    end

    # Deletes a treatment
    # @param treatment_name [string] the name of the treatment
    def delete_treatment(treatment_name)
      select_treatment(treatment_name)
      modal_treatment_delete.click
      page.driver.browser.switch_to.alert.accept
    end

  end
end