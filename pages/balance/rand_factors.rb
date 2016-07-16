require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class RandFactors < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    element :name, '#strata_factor_name' #text field
    element :weight, '#strata_factor_rand_weight' #text field
    element :save, '#update' #button
    element :cancel, 'img[alt="Cancel"]' #button
    element :delete, 'a[href="#Delete"]' #button
    element :add_state, '.add_nested_item' #button
    element :use_as_dosing_factor, '#strata_factor_used_as_dosing_factor' #checkbox

    element :modal_delete_factor, '#modal a.positive' #button
    element :modal_cancel, '#modal a.negative' #button

    elements :states, '.strata_factor_state input' #collection text fields

    # Inputs the rand factor states on the rand factor page
    # If more than 2 are passed, the add state button is clicked to
    # add more text fields and the states are set.
    # @param all_states [string] rand factor states delimited by ','
    def input_factor_states(all_states)
      my_states = all_states.split(',')
      for i in 0..my_states.size()-1
        add_state.click if i > 1
        states[i].set my_states[i]
      end
    end

    # Inputs factor fields and saves the page
    # @param name [string] name of the factor
    # @param weight [string] weight of the factor
    # @param states [string] states of the factor delimited by ','
    def add_factor(rf_name,rf_weight,rf_states)
      name.set rf_name
      weight.set rf_weight
      input_factor_states(rf_states)
      save.click
    end

    # Deletes a factor and confirms delete in modal
    def delete_factor()
      delete.click
      modal_delete_factor.click
    end

    # Sets the randomization factor to be used as a dosing factor
    def set_as_dosing_factor()
      use_as_dosing_factor.click
      save.click
    end

  end

end