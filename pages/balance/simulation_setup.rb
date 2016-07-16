require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class SimulationSetup < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :simulation_setup_table, Table, '#simulation_setup_list'

    element :new_simulation_setup, '.btn' #button
    element :simulation_name, '#simulation_setup_name' #field
    element :number_of_runs, '#simulation_setup_number_of_runs' #field
    element :number_of_subjects, '#simulation_setup_number_of_subjects' #field
    element :number_of_sites, '#simulation_setup_number_of_sites' #field
    element :save, 'li.button:nth-child(1) > button:nth-child(1)' #button
    elements :execute_simulations, '#simulation_setup_list td:nth-child(6) a' #link
    element :delete, 'li.button:nth-child(3) > button:nth-child(1)' #button
    elements :edit, '#simulation_setup_list td:nth-child(7) a' #link
    elements :simulation_name_setup, '#simulation_setup_list td.name' #field

    #Sets up the settings for a simulation
    #@param table [table] table of the simulation settings
    def simulation_setup(table)
      table.raw.each { |row|
        case row[0].downcase
          when 'simulation name'
            simulation_name.set row[1]
          when 'number of runs'
            number_of_runs.set row[1]
          when 'number of subjects'
            number_of_subjects.set row[1]
          when 'number of sites'
            number_of_sites.set row[1]
          else
            raise "Field name was not found."
        end
      }
      save.click
    end

    #Deletes a specified simulation
    #@param sim_name [string] name of the simulation
    def delete_simulations(sim_name)
      index = get_element_index(simulation_name_setup, sim_name)
      edit[index].click
      delete.click
      page.driver.browser.switch_to.alert.accept
    end

    #Executes a specified simulation
    #@param sim_name [string] name of the simulation that is needed to execute
    def execute_simulation(sim_name)
      index = get_element_index(simulation_name_setup, sim_name)
      execute_simulations[index].click
    end
  end
end
