require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class ManageSites < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :sites_table, Table, '#site_list'

    #textfield options
    element :name, '#site_name' #text field

    #dropdown options
    element :country, '#in_country' #dropdown
    element :depot, '#depot_id' #dropdown
    element :supply_plan, '#supply_plan_id' #dropdown
    element :shipping_status, '#active_for_drug_shipping' #dropdown
    element :assign_one_depot_dropdown, '#assign_one_depot_button' #dropdown

    #button options
    element :apply, '#apply_button' #button
    element :reset, '#reset_button' #button
    element :assign_supply_button, '#assign_supply_plan_button' #button
    element :assign_depot_button, '#assign_depot_button' #button
    element :activate_for_shipping, '#activate_for_shipping_button' #button
    element :deactivate_for_shipping_button, '#deactivate_shipping_button'
    element :assign_modal_save_button, '#modal_save' #button
    element :cancel, '#cancel' #button

    #table elements
    elements :site_names, '#site_list td:nth-child(2)'
    elements :site_checkboxes, '#site_list td:nth-child(1) input'
    elements :modal_name, '#modal #site_update_form label'
    elements :modal_radio_button, '#modal #site_update_form .selector input'

    #checkbox options
    #element :toggle_all, '#toggle_all' #checkbox
    element :toggle_all, '#checkbox_column input'

    #This method is adding a name in the search field and clicking apply. Somewhat of a filter
    #@param site_name[string] name of the specified site within the study
     def search_site_name(site_name)
      name.set site_name
      apply.click
     end

    #This method does a toggle all and assigns all sites to a depot
    #@param depot_name[string] name of the specified depot within the study
     def select_all_sites_depot(depot_name)
       toggle_all.set(true)
       assign_depot_button.click
       sleep 1
       modal_name.each_with_index do |depot_test,index|
        modal_radio_button[index].set(true)if depot_test.text==depot_name
       end
       assign_modal_save_button.click
     end

    #This method does a toggle all for all sites and assigns a specified supply plan.
    #@param supply_plan_param[string] name of the specified supply plan within the study
    def select_all_sites_supply_plan(supply_plan_param)
      toggle_all.click
      assign_supply_button.click
      sleep 1
      modal_name.each_with_index do |supply_plan_test, index|
        modal_radio_button[index].set(true) if supply_plan_test.text==supply_plan_param
      end
      assign_modal_save_button.click
    end

    #This method looks for a specific site name and checks the site checkbox within the page.
    #@param site_name[string] name of the specified site within the study
    def check_site(site_name)
      site_names.each_with_index do |site, index|
      site_checkboxes[index].set(true) if site.text==site_name
     end
    end

    #This method looks for a specific depot name and selects that depot as a checkbox within the modal.
    #@param site_name[string] name of the specified site within the study
    #@param depot_name[string] name of the specified depot within the study
    def assign_one_depot(site_name,depot_name)
      search_site_name(site_name)
      check_site(site_name)
      assign_depot_button.click
      assign_one_depot_dropdown.click
      sleep 1
      modal_name.each_with_index do |depot_test, index|
        modal_radio_button[index].set(true) if depot_test.text==depot_name
       end
       assign_modal_save_button.click
    end

    #This method activates a site for shipping
    #@param name[string] name of the specified site within the study
    def activate_shipping(name)
      search_site_name(name)
      check_site(name)
      activate_for_shipping.click
      assign_modal_save_button.click
    end

    #This method looks for a specific supply plan name and selects that supply plan as a checkbox within the modal.
    #@param supply_plan_param[string] name of the specified supply plan within the study
    def assign_supply_plan (supply_plan_param)
      assign_supply_button.click
      sleep 1
      modal_name.each_with_index do |supply_plan_test, index|
       modal_radio_button[index].set(true) if supply_plan_test.text==supply_plan_param
        end
        assign_modal_save_button.click
    end

    #This method deactivates a shipment flow
    #@param site_name[string] name of the specified site within the study
    def deactivate_shipping(site_name)
      search_site_name(site_name)
      check_site(site_name)
      deactivate_for_shipping_button.click
      assign_modal_save_button.click
    end
  end
end