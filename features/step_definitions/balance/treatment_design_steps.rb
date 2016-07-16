
When /^In Balance I create dosing factor "([^\"]*)" with levels "([^\"]*)"$/ do |name,levels|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.add_factor.click
  $applications.balance.dosing_factors.add_dosing_factor(name,levels)
end

When /^In Balance I delete dosing factor "([^\"]*)"$/ do |name|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.select_dosing_factor(name)
  $applications.balance.dosing_factors.delete_dosing_factor()
end

When /^In Balance I create article type with the following attributes:$/ do |attribute_table|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.add_new_article_type(attribute_table)
end

When /^In Balance I delete article type "([^\"]*)"$/ do |article_name|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.delete_article_type(article_name)
end

When /^In Balance I create a treatment "([^\"]*)" with DND of "([^\"]*)" and a composition of "([^\"]*)"$/ do |treatment,dnd,composition|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.add_new_treatment(treatment,dnd,composition)
end

When /^In Balance I delete treatment "([^\"]*)"$/ do |treatment_name|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.delete_treatment(treatment_name)
end

When /^In Balance I enable titrations$/ do
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.enable.click
end

When /^In Balance I disable titrations$/ do
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.disable.click
end

When /^In Balance I create (?:(un))?scheduled titration level set "([^\"]*)" with levels "([^\"]*)" and initial dose of "([^\"]*)"$/ do |type,name,levels,initial|
  step %Q{In Balance I navigate to the Treatment Design Page}
  $applications.balance.treatment_design.add_level_set.click
  $applications.balance.titration_levels.add_titration_level_set(name,type,levels,initial)
end
