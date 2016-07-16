
When /^In Balance I create a visit schedule with (\d+) visits, an offset of (\d+), start window of (\d+), end window of (\d+), and rand visit (\d+)$/ do |visits,offset,start_window,end_window,rand_visit|
  step %Q{In Balance I navigate to the Visits Page}
  $applications.balance.visits.create_visit_schedule(visits,offset,start_window,end_window,rand_visit)
end

When /^In Balance I delete visit "([^\"]*)"$/ do |visit_name|
  step %Q{In Balance I navigate to the Visits Page}
  $applications.balance.visits.delete_visit(visit_name)
end

When /^In Balance I set dosing for visit "([^\"]*)" to (on|off)$/ do |visit_name,dosing_option|
  step %Q{In Balance I navigate to the Visits Page}
  dosing_option == "on" ? dosing = true : dosing = false
  $applications.balance.visits.set_visit_dosing(visit_name,dosing)
end

When /^In Balance I assign visit "([^\"]*)" with titration level "([^\"]*)"$/ do |visit_name,titration|
  step %Q{In Balance I navigate to the Visits Page}
  $applications.balance.visits.set_titration_level(visit_name,titration)
end

When /^In Balance I update visit "([^\"]*)" to the new name of "([^\"]*)"$/ do |old_name, new_name|
  step %Q{In Balance I navigate to the Visits Page}
  $applications.balance.visits.update_visit_name(old_name, new_name)
end

# Example table
# | Old Visit Name  | New Visit Name  |
# | Visit 1         | Screening       |
# | Visit 2         | Rand Visit      |
# | Visit 3         | Visit 1         |
When /^In Balance I update multiple visit names with values below:$/ do |table|
  step %Q{In Balance I navigate to the Visits Page}
  table.hashes.each do |row|
    $applications.balance.visits.update_visit_name(row['Old Visit Name'], row['New Visit Name'])
  end
end

