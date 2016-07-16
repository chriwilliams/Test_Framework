# Performs key pair verifications on table
# This method will compare given header/value pair with information found in page
And /^I verify the following phase and indication information:$/ do |table|
  table.hashes.inject(&:merge).each do |key, value|
    expect($applications.study_design.benchmark_analysis.matches?(key, 'value', value)).to be_truthy
  end
end

# This method verifies that given table is found on page
And /^I verify the following tables are visible:$/ do |table|
  table.hashes do |data|
    expect($applications.study_design.benchmark_analysis.has?(data['table'], 'table')).to be_truthy
  end
end
