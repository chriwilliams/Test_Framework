require_relative 'draft'

module Rave
  class Project < Draft

    elements :crf_rows, 'table[id$="_DraftsGrid"] > tbody > tr'
    element :drafts_table ,'table[id$="DraftsGrid"]'
    element :crf_versions, 'table[id*="Content_VersionsGrid"]'
    element :rave_tab, 'table[id$="PgHeader_TabTable"]'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # Remove crf draft from list of drafts in project
    # @param draft [string] Draft Name
    def draft_remove(draft)
      crf_rows.each do |row|
          if row.text == draft
            remove_icon = row.find(:css, 'input[id$="DelDraft"]')
            remove_icon.click
            #click 'OK' on windows confirmation dialog
            page.driver.browser.switch_to.alert.accept
          end
      end
    end

    # selects the push link for a specified CRF Version
    # @param crf_name [String] the crf name you want to push
    def draft_push_click(crf_name = nil)
      crf_name = $crf_version if crf_name.nil?
      raise 'CRF version was not provided' if crf_name.nil?

      crf_versions.all('tr', :text => "#{crf_name}").each do |name|
        push_it = name.find(:css, 'a[id$="PushVersion"]')
        push_it.click
        break
      end
    end

    # Selects Draft from project page.
    # @param draft_name [string] draft name to open
    def draft_open(draft_name)
      found = false
      rows = drafts_table.all('tr')
      rows.each do |row|
        if row.text.downcase == draft_name.downcase
          found = true
          row.find_link(draft_name).click
          break
        end
      end
      raise "draft name #{draft_name} not found" unless found
    end

    # selects project tab via image
    def project_tab_select
      study = rave_tab.find(:css, 'img[src$="study_bl.gif"]')
      study.click
    end

  end
end