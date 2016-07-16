#Example
#|Name              |TestName    |
#|Number of Runes   |6           |
#|Number of subjects|10          |
#|Number of sites   |10          |

When /^In Balance I want to fill out the new simulation setup settings:$/ do |table|
  step %Q{In Balance I navigate to the Simulation Setups Page}
  $applications.balance.simulation_setup.new_simulation_setup.click
  $applications.balance.simulation_setup.simulation_setup(table)
end

When /^In Balance I execute for simulation "([^\"]*)"$/ do |sim_name_3|
  step %Q{In Balance I navigate to the Simulation Setups Page}
  $applications.balance.simulation_setup.execute_simulation(sim_name_3)
 end

When /^In Balance I delete simulation "([^\"]*)"$/ do |sim_name|
step %Q{In Balance I navigate to the Simulation Setups Page}
$applications.balance.simulation_setup.delete_simulations(sim_name)
end

When /^In Balance I download a list for simulation result "([^\"]*)"$/ do |sim_name2|
  step %Q{In Balance I navigate to the Simulation Results Page}
  $applications.balance.simulation_result.download_sim_list(sim_name2)
end

