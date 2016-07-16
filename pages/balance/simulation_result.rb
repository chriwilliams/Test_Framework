require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class SimulationResult < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :simulations_table, Table, '#simulation_execution_list'


    elements :show_results, '#simulation_execution_list td a' #link
    element :show_detailed_results #link
    element :download_simulated_subjects, '.btn' #button
    elements :simulation_name_results, '#simulation_execution_list td:nth-child(1)' #field

    #Downloads a simulated list
    #@param sim_name[string] name of the simulation needed to be downloaded

    def download_sim_list(sim_name)
      index = get_element_index(simulation_name_results, sim_name)
      show_results[index].click
      download_simulated_subjects.click
    end
  end
end
