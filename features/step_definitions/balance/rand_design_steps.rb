When /^In Balance I add (?:arm|regime) "([^\"]*)" with a ratio of (\d+)(?: and code "([^\"]*)")?$/ do |arm,ratio,code|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.add_arm.click
  $applications.balance.arms.add_arm(arm,ratio,code)
end

When /^In Balance I delete (?:arm|regime) "([^\"]*)"$/ do |study_arm|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.select_arm(study_arm)
  $applications.balance.arms.delete_arm
end

When /^In Balance I update (?:arm|regime) "([^\"]*)" ratio to (\d+)$/ do |study_arm,ratio|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.update_arm_ratio(study_arm,ratio)
end

When /^In Balance I create randomization factor "([^\"]*)" with(?: a weight of (\d+) and)? states "([^\"]*)"$/ do |rand_factor,weight,states|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.add_factor.click
  $applications.balance.rand_factors.add_factor(rand_factor,weight,states)
end

When /^In Balance I update randomization factor "([^\"]*)" weight to (\d+)$/ do |rand_factor,weight|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.update_factor_weight(rand_factor,weight)
end

When /^In Balance I delete randomization factor "([^\"]*)"$/ do |rand_factor|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.select_rand_factor(rand_factor)
  $applications.balance.rand_factors.delete_factor()
end

When /^In Balance I set randomization factor "([^\"]*)" as a dosing factor$/ do |rand_factor|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.select_rand_factor(rand_factor)
  $applications.balance.rand_factors.set_as_dosing_factor()
end

When /^In Balance I set (complete randomization|second best) probability to (\d+)$/ do |selection,probability|
  step %Q{In Balance I navigate to the Randomization Design Page}
  if selection=="complete randomization" then
    $applications.balance.rand_design.set_complete_randomization(probability)
  else
    $applications.balance.rand_design.set_second_best(probability)
  end
end

When /^In Balance I set the following randomize and dispense options$/ do |table|
  input = table.rows_hash
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.set_rand_dispense_options(input)
end

When /^In Balance I upload rand list "([^\"]*)" with block size (\d+) and header row of (\d+) located at "([^\"]*)"$/ do |name,block_size,header,file|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.upload_list.click
  $applications.balance.rand_list_upload.upload_rand_list(name,block_size,header,file)
end


#example input
# | Arm        | Active     |  2       |       |
# | Rand ID    | Random     |  100     |  200  |
# | Rand ID    | Sequential |  1       |       |
# | Sites      | 100        |  200     |       |
# | Block Size | 2          |  10      |       |
# | Rand Seed  | 293029323  |          |       |
When /^In Balance I generate rand list "([^\"]*)" with options:$/ do |list_name,options_table|
  step %Q{In Balance I navigate to the Randomization Design Page}
  $applications.balance.rand_design.generate_list.click
  $applications.balance.rand_list_generate.generate_list(list_name,options_table)
end


