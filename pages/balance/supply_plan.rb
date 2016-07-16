require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class SupplyPlan < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    # search elements
    #supply plan page buttons
    element :add_supply_plan_button, '#add_supply_plan_button' #button
    element :delete_button, 'img[alt="Trash"]'
    element :cancel_button, 'img[alt="Cancel"]'
    element :save, '#save'

    #dropdowns
    element :decoy_items, '#supply_plan_decoy_setting'
    element :supply_mode, '#supply_plan_shipping_settings'

    #supply plan page fields
    element :name_field, '#supply_plan_name' # name text field
    element :do_not_count, '#supply_plan_do_not_count'
    element :long_window, '#supply_plan_long_window'
    element :short_window, '#supply_plan_short_window'
    element :do_not_ship, '#supply_plan_do_not_ship'

    #checkbox
    element :default_plan_checkbox, '#supply_plan_default_plan'

    #table elements
    #table elements on the supply plan add/update page
    elements :initial_supply_field, '#supply_settings td:nth-child(2) input'
    elements :minimum_buffer_field, '#supply_settings td:nth-child(3) input'
    elements :max_buffer_field, '#supply_settings td:nth-child(4) input'

    #table elements on the supply plan list page
    elements :supply_plan_list_name, '#supply_plan_list td.name a'
    elements :at_name, '#name'

    #modal
    element :save_modal, '#modal img[alt="Check"]'

    # Creates a supply plan
    # @param sp_name [string] sets the name of the supply plan
    # @param sp_mode [string] selects the supply plan mode
    def create_supply_plan(sp_name,sp_mode)
     add_supply_plan_button.click
     name_field.set sp_name
     supply_mode.select sp_mode
    end

    # Deletes a specified supply plan
    # @param sp_name [string] name of specified supply plan name
    def remove_supply_plan(sp_name)
      edit_supply_plan(sp_name)
      delete_button.click
      page.driver.browser.switch_to.alert.accept #accepts browser modal popup
    end

    # Enters the edit page of a specified supply plan
    # @param sp_name [string] name of specified supply plan name
    def edit_supply_plan(sp_name)
      index = get_element_index(supply_plan_list_name, sp_name)
      supply_plan_list_name[index].click
      sleep 1
    end

    # Completes the supply settings table for a supply plan
    # @param table [table] supply setting options table
    def set_supply_settings(table)
      table.raw.each {|row|
       case row[0].downcase
        when 'long window'
         long_window.set row[1]
        when 'short window'
         short_window.set row[1]
        when 'do not count'
         do_not_count.set row[1]
         when 'do not ship'
         do_not_ship.set row[1]
        else
         raise "Field name was not found within the supply plan page."
       end
      }
      save.click
    end

    # Completes the buffer settings table for a supply plan
    # @param table2 [table] buffer settings options table
    def buffer_settings(table2)
      table2.hashes.each do |row|
      index = get_element_index(at_name, row['article name'])
      initial_supply_field[index].set row['init stock']
      minimum_buffer_field[index].set row['min buffer']
      max_buffer_field[index].set row['max buffer']
      end
      save.click
    end
  end
  end