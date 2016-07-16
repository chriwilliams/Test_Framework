require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'

module Coder

  class TermProperties < Common::BaseSection
    element :tab0, '#pcProperties_tab0'
    element :create_synonym_chk, '#chkCreateSynonym'
    element :code_btn, '#manualCode'
    element :code_and_next_btn, '#manualCodeNext'

    def select_code_properties(synonym_chk, workflow)
      create_synonym_check.set false unless synonym_chk.downcase == 'check'
      if workflow.downcase == 'code'
        code_btn.click
      else
        code_and_next_btn.click
      end
    end

  end

  class BrowserPage < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'
    section :term_properties, TermProperties, 'table[id*="pcProperties_CLW"]'

    element :dict_term_search_tab, 'a[id$="tab1"]'
    elements :dict_tree_table_rows, 'tr[id^="treeList_R"]'

    element :select_dict, 'select[id$="Dictionary"]'
    element :dict_version, 'select[id$="Version"]'
    element :syn_list, 'select[id$="SynonymList"]'
    element :template, 'select[id$="Template"]'
    element :level, 'select[id$="DictionaryLevel"]'
    element :term_or_code, 'select[id$="TermCode"]'
    element :text_to_search, 'input[id$="TxtSearchForText"]'
    element :search_btn, '#LnkBtnSearch'
    #element :search_btn, 'i[id$="Content_ImgSearch"]'
    element :expand_image_icon, 'img[class$="dxtl__Expand"]'
    element :min_score, 'select[id$="CutoffRank"]'

    # this method is used to set the parameter for searching for a term in any given dictionary
    # @param search_settings [Hash]. Pass in a Hash to make this work.
    def set_search_settings(search_settings)
      dict_term_search_tab.click
      select_dict.select search_settings['dict']
      dict_version.select search_settings['version']
      syn_list.select search_settings['syn_list']
      template.select search_settings['template']
      term_or_code.select search_settings['term_or_code']
      min_score.set search_settings['percentage']
    end

    # clicks on the search button
    # @param term [String]. Pass in the term you would like to search with.
    def search(term)
      wait_for_dict_term_search_tab
      dict_term_search_tab.hover
      dict_term_search_tab.click
      text_to_search.set term
      search_btn.click
    end

    # codes a term based on the parameter given.
    # @param code_params [Hash]. Provide if you would like the coded term will create a synonym or not.
    # @param row_num [Integer]. Prove the row to select from dictionary tree table.
    def code_term(code_params, row_num)
      sleep 2
      page.driver.browser.switch_to.frame('FrmCodingBrowser')
      select_table_row = (row_num.to_i - 1) # table row seems to be indexed at 0.
      dict_tree_table_rows.at(select_table_row).click
      wait_for_dict_tree_table_rows
      dict_tree_table_rows.at(0).hover
      term_properties.select_code_properties(code_params['checkbox'], code_params['manualCode'])
      page.driver.browser.switch_to.default_content
      sleep 1
    end

  end

end