module Common

  # takes a validation screenshot
  def take_screenshot
    if Object.const_defined?('Shamus')
      filename = Shamus.current.current_step.add_inline_asset('.png', Shamus::Cucumber::InlineAssets::RENDER_AS_IMAGE)
      self.save_screenshot(filename)
    end
  end

  # prints text to console or shamus output
  # @param text [string] the text you want to print to the console or shamus output
  def print_to_output(text)
    if Object.const_defined?('Shamus')
      asset = Shamus.current.current_step.add_inline_asset('.txt', Shamus::Cucumber::InlineAssets::RENDER_AS_TEXT)
      File.open(asset, 'w') { |f| f.puts("#{text}") }
    else
      puts "#{text}"
    end
  end

  # Returns true or false depending on the string value
  # @param value [String] the variable that is checked being true or false
  def to_bool(value)
    value.to_s.downcase == 'true' ? true : false
  end

  # Returns the index of an element in a collection
  # @param element_collection [collection] The collection of your elements
  # @param element_name [string] The element to find
  # @param raise_error [boolean] Flag to raise error if not found, default = true
  # @param type [string] check element text or value (if its input element you must use value), default = text
  # @return [int] The index of your element
  def get_element_index(element_collection, element_name, raise_error = true, type = 'text')
    all_e = ""
    element_collection.each_with_index do |e, index|
      type == 'text' ? e = e.text : e = e.value
      all_e += e
      all_e += ", " if element_collection.size > index+1
      if e == element_name
        return index
      end
    end

    raise "#{element_name} not found in your element collection: #{all_e}" if raise_error
  end

  # Returns true or false depending on the parameter being nil or empty
  # @param value [String] the variable that is checked being nil or empty
  def nil_or_empty?(value)
    value.nil? || value.empty? ? true : false
  end

  # interacts with file upload prompts
  # @param locator [String] the field to attach file to. Can be name, id, or label text
  # @param file_path [String] the file path and name.
  def upload_file(locator, file_path)
    if File.exist?(file_path)
      self.attach_file(locator, file_path)
    else
      raise "File #{file_path} not found."
    end
  end
end
