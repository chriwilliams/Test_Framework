And /^I verify the following data under Cost \& Complexity panel:$/ do |table|
  $applications.study_design.analytics.verify_items_in_cost_complexity_section(
      table.hashes.map { |rows| rows.keys.select { |row| ['Minimum', 'Maximum', 'Expected'].include? row }.collect { |key| {[key.capitalize, rows['']].join(' ') => rows[key]} } }.flatten.inject(&:merge)
  )
end

And /^I verify the Protocol Complexity vs. Industry Benchmark chart contains the following data:$/ do |table|
  $applications.study_design.analytics.verify_protocol_complexity_chart_contents(table.rows_hash)
end

And /^I verify the pie chart is present for the "([^"]+)" chart$/ do |title|
  $applications.study_design.analytics.verify_pie_present(title)
end

And /^I verify the following legends are present within the pie chart:$/ do |table|
  $applications.study_design.analytics.verify_activity_chart_legends(table.hashes)
end

And /^I (open|close) the View Chart Details table section(?: for "([^"]+)")?$/ do |action, selection|
  $applications.study_design.analytics.toggle_view_chart_details(action.downcase=='open', selection)
  sleep 0.01
  step %Q{the View Chart Details table is not visible within the "Analytics" page} if action.downcase=='close'
end

And /^I verify these total values within the View Chart Details table:$/ do |table|
  $applications.study_design.analytics.verify_view_chart_table_total(table.hashes)
end

And /^I note the current cost and complexity$/ do
  $sticky[:cost_value] = $applications.study_design.analytics.clinical_activity_site_cost_per_subject
  $sticky[:complexity_value] = $applications.study_design.analytics.protocol_complexity_per_subject
end

And /^I verify the (Cost Per Subject|Complexity Per Subject) (has changed|has increased|has decreased|is the same|has not changed)$/ do |object, comparison|
  case object
    when 'Cost Per Subject'
      current = $applications.study_design.analytics.clinical_activity_site_cost_per_subject
      expected = $sticky[:cost_value] || []
      when 'Complexity Per Subject'
        current = $applications.study_design.analytics.protocol_complexity_per_subject
        expected = $sticky[:complexity_value] || []
  end

  case comparison
    when /^has changed$/
      raise StandardError, "Current value: #{current} fails to compare with Expected: #{expected}" unless current != expected
    when /^has increased/
      raise StandardError, "Current value: #{current} fails to compare with Expected: #{expected}" unless current[1].gsub(/[\$,\,]/,'').strip.to_f > expected[1].gsub(/[\$,\,]/,'').strip.to_f
    when /^has decreased/
      raise StandardError, "Current value: #{current} fails to compare with Expected: #{expected}" unless current[1].gsub(/[\$,\,]/,'').strip.to_f < expected[1].gsub(/[\$,\,]/,'').strip.to_f
    when /^has not changed$/, /^is the same$/
      raise StandardError, "Current value: #{current} fails to compare with Expected: #{expected}" unless current == expected
  end
  step %Q{I Print content "VERIFIED : #{object} value #{comparison} as expected" to shamus output}
end
