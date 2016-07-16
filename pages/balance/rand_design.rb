require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class RandDesign < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :study_arms_table, Table, '#study_arms'
    section :randomization_factors_table, Table, '#randomization_factors'


    # Header
    element :logout, '#logout' #link
    element :imedidata_logo, '#imedidata_logo' #link

    #rand method selection
    element :rand_design, '#randomization_method_select' #dropdown
    element :modal_continue, '#modal #continue_button' #button
    element :modal_cancel, '#modal #cancel'


    #study arm options
    element :add_arm, '#add_regime' #button
    elements :study_arms, '#study_arms #name a' #collection links
    elements :arm_ratios, '#study_arms #ratio input' #collection input fields

    #randomization factor options
    element :add_factor, '#add_factor' #button
    elements :rand_factors, '#randomization_factors #factor' #collection links
    elements :factor_weights, '#randomization_factors #weight input.input_short' #collection input fields

    #CR/Second Best options
    element :complete_rand_radio, '#study_design_randomization_method_5' #radio button
    element :complete_rand_input, '#prob_complete_rand' #text field
    element :second_best_radio, '#study_design_randomization_method_1' #radio button
    element :second_best_input, '#rand_second_best_prob' #text field


    #PB options
    element :stratification, '#study_design_using_stratification' #checkbox
    element :site_stratification, '#study_design_blocked_by_site' #checkbox
    element :pre_allocate, '#study_design_preallocation_on' #checkbox
    element :generate_list, '#generate_list_button' #button
    element :upload_list, '#upload_list_button' #button

    #rand disp options
    element :rand_disp_all_arms, '#study_design_rand_and_dispense_option_1' #radio button
    element :rand_disp_available_arm, '#study_design_rand_and_dispense_option_3' #radio button
    element :rand_disp_forced_alloc, '#study_design_rand_and_dispense_option_2' #radio button
    element :forced_alloc_expander, '#expander' #expander button
    element :forced_alloc_arm_count, '#study_design_minimum_arms_for_rand_and_dispense' #dropdown
    element :rand_disp_not_coupled, '#study_design_rand_and_dispense_option_0' #radio button

    #general
    element :save, '#save' #button
    element :cancel, 'img[alt="Cancel"]' #button


    # Clicks on the given arm in the study arms table
    # @param arm [string] arm name
    def select_arm(arm)
      index = get_element_index(study_arms, arm)
      study_arms[index].click
    end

    # Clicks on the given randomization factor in the rand factor table
    # @param factor [string] factor name
    def select_rand_factor(factor)
      index = get_element_index(rand_factors, factor)
      rand_factors[index].find('a').click
    end

    # Slects complete randomization and sets probability
    # @param probability [string] complete rand probability
    def set_complete_randomization(probability)
      complete_rand_radio.click
      complete_rand_input.set probability
      save.click
    end

    # Slects second best randomization and sets probability
    # @param probability [string] second best probability
    def set_second_best(probability)
      second_best_radio.click
      second_best_input.set probability
      save.click
    end

    # Selects the rand and dispsense options
    # @param input [hash table] key value pairs of rand dispense options
    def set_rand_dispense_options(input)
      case input['Rand and Dispense Option']
        when 'All Arms'
          rand_disp_all_arms.click
        when 'Available Arms'
          rand_disp_available_arm.click
        when 'Forced Allocation'
          rand_disp_forced_alloc.click
          forced_alloc_expander.click
          forced_alloc_arm_count.select input['Arm Count']
        else
          rand_disp_not_coupled.click
      end
      save.click
    end

    # Selects the rand method
    # @param rand_method [string] the randomization method to select
    def select_rand_method(rand_method)
      rand_design.select rand_method
      modal_continue.click
    end

    # Sets the arm ratio
    # @param arm_name [string] name of the arm
    # @param ratio [string] the ratio to set
    def update_arm_ratio(arm_name,ratio)
      index = get_element_index(study_arms, arm_name)
      arm_ratios[index].set ratio
      save.click
    end

    # Sets the factor weight
    # @param factor_name [string] name of the randomization factor
    # @param weight [string] the weight to set
    def update_factor_weight(factor_name,weight)
      index = get_element_index(rand_factors, factor_name)
      factor_weights[index].set weight
      save.click
    end

  end
end