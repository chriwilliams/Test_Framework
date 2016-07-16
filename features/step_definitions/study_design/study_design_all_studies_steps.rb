When(/^I\s?(?:should|can)? see the following (headers) within the "([^"]+)" (#{CONTAINER}):$/) do |tag, container, ctag, table|
  colname = (tag =~ /field/) ? 'field' : tag.downcase.singularize

  table.hashes.each do |row|
    case colname
      when 'header'
        step %Q{I see the "#{row[colname]}" #{colname} within the "#{container}" #{ctag}}
    end
  end
end

When(/^I select the study "([^"]+)" within Design Optimization landing page$/) do |study|
  $applications.study_design.all_studies.loadStudy(study)
end
