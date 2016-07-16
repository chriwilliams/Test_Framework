require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class DraftUpload < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'

    element :backup, 'input[id="MakeBackup"]'
    element :submit, 'input[name$="Content:Upload"]'
    element :status, 'span[id="CurrentStatus"]'

    set_url_matcher /\/medidatarave\//i

    # uploads the draft in Rave Architect
    # @param file_path [String] the path and file name of the draft you want to upload
    def draft_upload(file_path)
      if File.exist?(file_path)
        ext = File.extname(file_path).downcase
      else
        raise "Draft File #{file_path} not found."
      end

      case ext
        when '.xls', '.zip', '.xlsx', '.xml'
          upload_file('CtrlDraftFile', file_path)
          submit.click
        else
          raise "Invalid draft file '#{File.basename(file_path)}'."
      end

      status_text = ''
      t = Time.now
      timeout = t + (60*5) # 5 minutes max.
      until status_text == 'save successful' || status_text == 'transaction rolled back' || timeout <= Time.now do
        status_text = status.text.downcase
      end

      raise 'Draft upload was unsuccessful. Please try again.' unless status_text == 'save successful'
    end

    # enable or disable save draft history for roll back
    # @param save_it [Boolean] whether or not you want to save draft history for roll back
    def save_history(save_it = true)
      if save_it?
        self.backup.set true
      else
        self.backup.set false
      end
    end

    # updates draft name in xls file for the draft upload.
    # @param project_name [string] project name
    # @param excel_filename [string] draft template file path
    # @param excel_filename_new [string] draft file path to be used for the upload with replaced draft name
    def excel_draft_name_update(project_name, excel_filename, excel_filename_new)
      textfile = File.new(excel_filename, "r")
      temparray = [""]
      newodm = [""]

      temparray = temparray + textfile.readlines
      temparray.each { |fileline|
        if fileline =~ /(ProjectNameToReplaceText)/
          fileline = fileline.gsub($1,"#{project_name}")
          newodm.push("#{fileline}")
        else
          newodm.push("#{fileline}")
        end
      }
      begin
        outfile = File.new("#{excel_filename_new}", "w")
        newodm.each{ |odminfo| outfile.write odminfo}
      ensure
        outfile.close
        textfile.close
      end
    end

  end
end