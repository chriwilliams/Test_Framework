require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Draft < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'

    elements :tabs, 'a[id*="PgHeader_TabTextHyperlink"]'
    element :publish, 'input[id$="Content_BtnPublish"]'
    element :crf_name, 'input[id$="Content_TxtCRFVersion"]'
    element :crf_exists, 'table[id*="Content_VersionGrid"]'
    element :crf_error, 'span[id$="LblPublishWarning"]'
    element :edit_link, 'a[id$="EditButtonLnk"]'
    element :save, 'a[id$="SaveButtonLnk"]'
    element :signature_prompt, 'input[id$="TxtSignaturePrompt"]'
    element :default_matrix, 'select[id$="DefaultMatrix"]'

    # publishes a draft on the page
    # @param crf_name [String] the name of the CRF Version you want to publish
    def draft_publish(crf_name)
      self.crf_name.set "#{crf_name}"

      publish.click

      # only grab the first like element to get the full version name
      crf_exists.all('td', :text => "#{crf_name}").each do |name|
        $crf_version = name.text
        break
      end
    end

    # Open draft item from list of drafts in project
    # @param item_name [string] Draft Name
    def draft_item_open(item_name)
      draft_item_link = find_link(item_name)
      draft_item_link.click
    end

    def select_tab(draft_name)
      navigation_tabs = tabs.detect { |inner_item| inner_item.text == draft_name }
      raise "Navigation tab #{draft_name} not found" unless navigation_tabs
      navigation_tabs.click
    end

    # use this method to edit fields on a draft for a study. Currently this method is written for Coder purposes only
    # @param sign_prompt [String] text to enter in Signature Prompt field
    # @param matrix [String] Matrix to be used at default for this draft
    def edit_draft(sign_prompt, matrix)
      wait_for_edit_link
      edit_link.click
      signature_prompt.set sign_prompt
      default_matrix.select matrix
      save.click
      sleep 1
    end

  end
end
