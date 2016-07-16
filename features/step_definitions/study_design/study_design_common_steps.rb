When /^in (Design Optimization|Study Design),\s(.+[^:])$/i do |app, action_step|
  expect($applications.study_design.scenario.displayed?).to be_truthy
  step %Q{#{action_step}}
end

When /^in (Design Optimization|Study Design),\s(.+):$/ do |app, action_step, table|
  expect($applications.study_design.scenario.displayed?).to be_truthy
  step %Q{#{action_step}:}, table
end
