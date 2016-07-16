# Example inputs
# | Arm          | All         |
# | Arm          | None        |
# | Arm          | Arm Name    |
# | Visit        | Visit Name |
# | Gender Level | Gender      |
# .....etc
When /^In Balance I assign treatment "([^\"]*)" to a filter of:$/ do |treatment_name,filter_table|
  step %Q{In Balance I navigate to the Assign Treatments Page}
  $applications.balance.assign_treatments.assign_treatment(treatment_name,filter_table)
end