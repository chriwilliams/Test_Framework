When(/^In "([^"]+)",\s*(.+)$/) do |app, step_def|
  case app.downcase
    when 'design optimization','study design'
      step %Q{#{step_def}}
  end
end