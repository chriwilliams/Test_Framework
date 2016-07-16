include JanusSelectorHelpers


When(/^I insert "([^"]+)" into the "TinyMC" iframe within the "([^"]+)" (#{TAGS})$/) do |content, container, tag|
    setContent('tinyMCE', content)
end




def getContent(editor)
  begin
    evaluate_script("#{editor}.activeEditor.focus();")
    value =  evaluate_script("#{editor}.activeEditor.getContent();")
    evaluate_script("#{editor}.activeEditor.focus(false);")
  rescue
    value = nil
  end
  return value
end

def setContent(editor, value)
  evaluate_script("#{editor}.activeEditor.setContent( '#{value}' );")
  evaluate_script("#{editor}.activeEditor.focus(false);")
end