require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class DosingFactors < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    element :name, '#dosing_factor_name' #text field
    element :add_level, '#add_nested_item_button' #button
    elements :dosing_factor_levels, '#dosing_factor_levels input[type=text]' #collection text fields
    element :save, '#update' #button
    element :cancel, '#cancel_button' #button
    element :delete, '#del_df_button' #button

    element :modal_delete_factor, "#modal button[data-method='delete']" #button
    element :modal_cancel, '#modal a.negative' #button

    # Input the dosing levels on the dosing factors page
    # If more than 2 are passed, the add level button is clicked to
    # add more text fields and the levels are set.
    # @param levels [string] dosing levels delimited by ','
    def input_dosing_levels(levels)
      my_levels = levels.split(',')
      for i in 0..my_levels.size()-1
        add_level.click if i > 1
        dosing_factor_levels[i].set my_levels[i]
      end
    end

    # Inputs dosing factor fields and saves the page
    # @param df_name [string] name of the dosing factor
    # @param levels [string] levels of the dosing factor delimited by ','
    def add_dosing_factor(df_name,levels)
      name.set df_name
      input_dosing_levels(levels)
      save.click
    end

    # Deletes the dosing factor and confirms delete factor in the modal
    def delete_dosing_factor()
      delete.click
      modal_delete_factor.click
    end

  end
end