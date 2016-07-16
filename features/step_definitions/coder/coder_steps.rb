And(/^I set coder and rave defaults with the following options:$/) do |table_data|
  input = table_data.rows_hash
  study_group =  step %Q{I check if value "#{input[:StudyGroup]}" is a sticky value from the config file}
  project = step %Q{I check if value "#{input[:project]}" is a sticky value from the config file}
  app = 'Coder'
  if app.downcase.include? 'coder'
    $applications.imedidata.home.search_by(:study, study_group)
    $applications.imedidata.home.select_item_by_partial_match(:app, app)
  end
  sleep 2
  step %Q{in Coder I clean up segment}
  step %Q{in Coder I reset cache}
  step %Q{in Coder I set medDRA configuration to use primary path and create active synonyms}
  step %Q{in Coder I create and activate a new Synonym List named "#{input[:syn_list_name]}" using Dictionary "#{input[:Dictionary]}", version "#{input[:version]}" and  Locale "#{input[:locale]}"}
  step %Q{in Coder I register study "#{project}" using Synonym List named "#{input[:syn_list_name]}"  Dictionary "#{input[:Dictionary]}", version "#{input[:version]}" and  Locale "#{input[:locale].downcase}"}
  step %Q(I navigate to iMedidata from "Coder")
  step %Q{I navigate to "Rave EDC" for study group "#{project}" from iMedidata}
  step %Q{I restore Rave defaults for Coder project "#{project}" with file named "#{input[:ConfigFile]}" with draft "#{input[:Draft]}"}
end

And(/^in Coder I clean up segment$/) do
  $applications.coder.task_page.navigation.navigate_to_page('CodingCleanup')
  $applications.coder.code_cleanup_page.remove_synonym_proj_reg
end

And(/^in Coder I reset cache$/) do
  $applications.coder.task_page.navigation.navigate_to_page('Reset Cache')
  $applications.coder.reset_cache_page.flush_all_cache
end

And(/^in Coder I set medDRA configuration to (use|not to use) primary path and create (active|inactive) synonyms?$/)do |use_primary_path, active_inactive_synonym|
  $applications.coder.task_page.navigation.navigate_to_page('Configuration')
  (use_primary_path == 'use') ? primary_path = 'ON' : primary_path = 'OFF'
  (active_inactive_synonym == 'active') ? synonym_policy = 'active' : synonym_policy = 'inactive'
  $applications.coder.configuration_page.set_meddra_configuration(primary_path, synonym_policy)
end

And(/^in Coder I set coder defaults with the following options:/) do |table|
  input = table.rows_hash
  study_group =  step %Q{I check if value "#{input[:StudyGroup]}" is a sticky value from the config file}
  project = step %Q{I check if value "#{input[:project]}" is a sticky value from the config file}
  app = 'Coder'
  if app.downcase.include? 'coder'
    $applications.imedidata.home.search_by(:study, study_group)
    $applications.imedidata.home.select_item_by_partial_match(:app, app)
  end
  sleep 2
  step %Q{in Coder, I clean up segment}
  step %Q{in Coder I reset cache}
  step %Q{in Coder I set medDRA configuration to use primary path and create active synonym}
  step %Q{in Coder I create and activate a new Synonym List named "#{input[:syn_list_name]}" using Dictionary "#{input[:Dictionary]}", version "#{input[:version]}" and  Locale "#{input[:locale]}"}
  $applications.coder.task_page.navigation.navigate_to_page('Project Registration')
  $applications.coder.project_registration.register_project(project, input[:Dictionary], input[:version], input[:locale].downcase,input[:syn_list_name])
end

And(/^in Coder I register study "([^"]*)" using Synonym List named "([^"]*)"  Dictionary "([^"]*)", version "([^"]*)" and  Locale "([^"]*)"$/) do |project, list_name, dictionary, version, locale|
  project = step %Q{I check if value "#{project}" is a sticky value from the config file}
  $applications.coder.task_page.navigation.navigate_to_page('Project Registration')
  $applications.coder.project_registration.register_project(project, dictionary, version, locale.downcase, list_name)
end

And(/^in Coder I wait for (\d+) tasks? to show up in the task page$/) do |how_many|
  $applications.coder.task_page.verify_task_num(how_many)
end

Then(/^in Coder I should see verbatim term "([^"]*)" located in Coder Main Table$/) do |vb_term|
  $applications.coder.task_page.verify_vb_term(vb_term)
end

When(/^in Coder I select workflow action "([^"]*)" for term "([^"]*)" in Coder Main Table on row "([^"]*)"$/) do |workflow_action, vb_term, row_number|
  # TODO: select the term if it shows up on the first page, or else go to the next page
  # The row selection would be based on either term or row number. We use row number for now
  vb_term = $sticky[vb_term.to_sym] if $sticky.has_key? vb_term.to_sym
  $applications.coder.task_page.select_action_for_row(workflow_action, row_number)
end

# this code below is yet not tested and the step will be removed later
And(/^in Coder I navigate to "([^"]*)" page$/) do |page|
  $applications.coder.task_page.navigation.navigate_to_page page
end

And(/^in Coder I create and activate a new Synonym List named "([^"]*)" using Dictionary "([^"]*)", version "([^"]*)" and  Locale "([^"]*)"$/) do |list_name, dictionary, version, locale|
  $applications.coder.task_page.navigation.navigate_to_page('Synonym')
  $applications.coder.synonym_page.create_and_start_synonym_list(list_name, dictionary, version, locale)
end

And(/^in Coder I select tab "([^"]*)"$/) do |tab|
  $applications.coder.project_registration.navigation.select_tab 'browser'
end

And(/^in Coder I select the following values in Dictionary Tree Table, check the synonym checkbox and select workflow button:$/) do |table|
  input = table.rows_hash
  code_params = {}
  code_params['row'] = input['row']
  code_params['checkbox'] = input['checkbox']
  code_params['workflow_btn'] = input['workflow button']
  $applications.coder.browser_page.code_term(code_params, input['row'])
end

And(/^in Coder I search for a matching term with following dictionary selections:$/) do |table|
  input = table.rows_hash
  search_settings = {}
  search_settings['dict'] = input['Dictionary']
  search_settings['version'] = input['version']
  search_settings['syn_list'] = input['synonym list']
  search_settings['template'] = input['template']
  search_settings['term_or_code'] = input['search criteria']
  search_settings['percentage'] = input['search percentage']
  #search_settings['term'] = input['term']
  $applications.coder.browser_page.set_search_settings(search_settings)
  $applications.coder.browser_page.search(input['term'])
  sleep 2
end

When(/^in Coder I select term "([^"]*)" in Coder Main Table on row "([^"]*)"$/) do |vb_term, row|
  ($sticky.has_key? vb_term.to_sym) ? vb_term = $sticky[vb_term.to_sym] : vb_term = vb_term
  $applications.coder.task_page.verify_term_and_select_row(vb_term, row)
end

And(/^in Coder I select (Source Terms|Properties|Assignments|Coding History|Query History) tab on Coder Main Page$/) do |tab|
  tab_to_select = tab.downcase
  $applications.coder.task_page.select_details_tab tab_to_select
end

And(/^in Coder I assign user "([^"]*)" to "([^"]*)" module for "([^"]*)" with value "([^"]*)" and  with role "([^"]*)"$/) do |user, security_module, study_dict_seg, item, role|
  # And I assign user "limitedcoder6" to "Dictionary" module for "Dictionary" with value "All Medical Dictionary" and  with role "DictionaryAdmin"
  $applications.coder.task_page.navigation.navigate_to_page('Assign General Role')
  if security_module.downcase == 'dictionary'
    $applications.coder.assign_general_role.select_security_module ('Page Dictionary Security')
  elsif security_module.downcase == 'study'
    $applications.coder.assign_general_role.select_security_module ('Page Study Security')
  elsif security_module.downcase == 'segment'
    $applications.coder.assign_general_role.select_security_module ('Segment Security')
  else
    raise 'You passed in a module selection which is not found in the drop-down items or compatible with this method.'
  end
  ## please pass in the parameter in Camelize cases or else it will fail ##
  case study_dict_seg
    when 'Study'
      $applications.coder.assign_general_role.assign_study_role user, item, role
    when 'Dictionary'
      $applications.coder.assign_general_role.assign_dictionary_role user, item, role
    when 'Segment'
      $applications.coder.assign_general_role.assign_segment_role user, item, role
    else
      raise 'Your input does not match with a possible selection on the UI. Please verify your input.'
  end
  sleep 2
end

And(/^in Coder I upgrade newly created synonym list from Dictionary Version "([^"]*)" and synonym list "([^"]*)"$/) do |version, syn_list|
  $applications.coder.synonym_page.upgrade(version, syn_list)
end

And(/^in Coder I create a new Synonym List named "([^"]*)" using Dictionary "([^"]*)", version "([^"]*)" and  Locale "([^"]*)"$/) do |syn_list_name, dictionary, version, locale|
  $applications.coder.task_page.navigation.navigate_to_page('Synonym')
  $applications.coder.synonym_page.create_synonym_list(syn_list_name, dictionary, version, locale)
end

And(/^in Coder I open a query with query text "([^"]*)" for term "([^"]*)" on row (\d+)$/) do |query_text, term, row|
  term = $sticky[term.to_sym] if $sticky.has_key? term.to_sym
  $applications.coder.task_page.verify_term_and_select_row(term, row)
  $applications.coder.task_page.open_query(query_text)
end

When(/^in Coder I am in Coder segment "([^"]*)"$/) do |segment|
  app = 'Coder'
  if app.downcase.include? 'coder'
    $applications.imedidata.home.search_by(:study, segment)
    $applications.imedidata.home.select_item_by_partial_match(:app, app)
  end
  sleep 1
end

And(/^in Coder I wait for term "([^"]*)" on row "([^"]*)" to appear with Query status "([^"]*)"$/) do |term, row, status|
  term = $sticky[term.to_sym] if $sticky.has_key? term.to_sym
  #$applications.coder.task_page.verify_coder_is_loaded
  step %Q{I search for term "#{term}" and wait for result}
  $applications.coder.task_page.verify_term_and_select_row(term.downcase, row)
  $applications.coder.task_page.verify_query_status(row.to_i,term.downcase, status.downcase)
end

And(/^in Coder I Browse and Code Term "([^"]*)" on row (\d+), entering value "([^"]*)" and selecting dictionary tree row (\d+) and "([^"]*)"$/) do |vb_term,term_row, search_value, dict_row, syn_policy|
  vb_term = $sticky[vb_term.to_sym] if $sticky.has_key? vb_term.to_sym
  step %Q{in Coder I select workflow action "Browse and Code" for term "#{vb_term}" in Coder Main Table on row "#{term_row}"}
  $applications.coder.browser_page.search("#{search_value}")
  sleep 3
  code_params = Hash.new
  code_params['row'] = dict_row.to_i
  if
  syn_policy.downcase == 'create synonym'
    code_params['checkbox'] = 'check'
  else
    code_params['checkbox'] = 'uncheck'
  end
  code_params['manualCode'] = 'Code'
  $applications.coder.browser_page.code_term(code_params, code_params['row'])
  sleep 2
end

And(/^in Coder I perform a synonym migration for list "([^"]*)" from Dictionary Version "([^"]*)" and start to reconcile by accepting "([^"]*)" suggestion$/) do |syn_list, dict_version, pick_suggestion|
  $applications.coder.synonym_page.verify_migration_complete syn_list
  $applications.coder.synonym_page.reconcile_by_accepting_suggestion pick_suggestion
end

And(/^in Coder I perform a study migration on Study "([^"]*)" using following data:$/) do |study, table|
  $applications.coder.task_page.navigation.navigate_to_page('Study Impact Analysis')
  select_options = table.transpose.rows_hash
  dictionary = select_options['Dictionary']
  from_version = select_options['From Version']
  from_syn_list = select_options['From Syn List']
  to_version = select_options['To Version']
  to_syn_list = select_options['To Syn List']
  $applications.coder.study_impact_analysis.study_migration_selections(study,dictionary, from_version,from_syn_list,to_version, to_syn_list)
  $applications.coder.study_impact_analysis.perform_study_migration
end

And(/^in Coder I verify the following data in Reference Table:$/) do |table|
  step %Q{in Coder I select Source Terms tab on Coder Main Page}
  table.hashes.each do |data|
    name = data['Name']
    value = data['Value']
    value = $sticky[value.to_sym] if $sticky.has_key? value.to_sym
    actual_value = $applications.coder.task_page.get_reference_value(name)
    expect(actual_value.downcase).to eq(value.downcase)
  end
end

And(/^in Coder I search for term "([^"]*)"$/) do |term|
  $applications.coder.task_page.search_for_term term
end
And(/^in Coder I verify the following in Source Term tab for Supplements table:$/) do |table|
  step %Q{in Coder I select Source Terms tab on Coder Main Page}
  table.hashes.each do |data|
    name = data['Supplemental Term']
    value = data['Supplemental Value']
    actual_value = $applications.coder.task_page.get_supplement_value(name)
    expect(actual_value).to eq(value)
  end
end

And(/^in Coder I search for term "([^"]*)" and wait for result$/) do |term|
  ($sticky.has_key? term.to_sym) ? term = $sticky[term.to_sym] : term = term
  step %Q{I Print content "Term : #{term}" to shamus output}
  $applications.coder.task_page.wait_for_term term
end

And(/^in Coder I expect to see the following verbatim terms in Coder Main Table$/) do |table|
  terms = Array.new
  table.raw.each { |elem| elem.each { |term| terms << term} }
  terms.each do |each_term|
    $applications.coder.task_page.verify_vb_term each_term
  end
end

And(/^in Coder I (remove|clean up) coding tasks$/) do |selection|
  $applications.coder.task_page.navigation.navigate_to_page('CodingCleanup')
  $applications.coder.code_cleanup_page.clean_up_coding_tasks
end

And(/^in Coder I verify the following terms? (do|does) not exist in Coder Main Table:$/) do |terms_table|
  terms = Array.new
  terms_table.raw.each{|each_term| each_term.each {|term| terms << term}}
  terms.each do|every_term|
    $applications.coder.task_page.verify_vb_term_not_there  every_term
  end
end

And(/^I select coded link "([^"]*)" in Coder Main Table$/) do |link_to_select|
  $applications.coder.task_page.verify_coder_is_loaded
  $applications.coder.task_page.select_coded_term_link link_to_select
end


Given(/in "([^"]*)" I have configurable data set from the following:$/) do |app, config_data|
  # Get data from the config file and define them as stickys
  # Used to set Coder user and study information
  # Can add more stickys for different values as needed
  input = config_data.rows_hash
  app_to_use = app.downcase
  $sticky[:user_name] = $config['ui']['apps'][app_to_use][input[:UserName]]
  $sticky[:project_name] = $config['ui']['apps'][app_to_use][input[:Project]]
  $sticky[:study_group] = $config['ui']['apps'][app_to_use][input[:StudyGroup]]
end

