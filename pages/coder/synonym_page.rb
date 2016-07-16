require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class SynonymPage < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :select_dictionary, 'select[id$="ddlDictionaries"]'                     # dropdown
    element :select_locale, 'select[id$="ddlLocales"]'                              # dropdown
    element :select_dictionary_version, 'select[id$="ddlVersions"]'                 # dropdown
    element :active_list_only_checkbox, 'input[id$="ChkDisplayActivatedListOnly"]'  # checkbox
    element :syn_name, 'input[id*="Content_dversions_DXEditor0"]'                   # text_field
    element :add_new, 'a[id$="LnkAddNewdversions"]'                                 #link
    element :upgrade_synonym_list, 'tr[id*="Content_dversions_DXDataRow"] > td:nth-child(4) > a'   # link
    element :start_synonym_list, 'a[id*="Content_upSynACG_dontUpBtn"]'              # link
    element :migration_version, 'need-to-add-id'
    element :save_synonym_list, 'tr[id$="DXEditingRow"] > td.dxgvCommandColumn_Main_Theme.dxgv > img:nth-child(1)'
    element :synonym_creation_message, '#ctl00_StatusPaneACG_SuccessPane > div > div > div > table > tbody > tr > td:nth-child(1) > span'
    element :migrate_from_version, 'select[id$="ddlDictionaryVersions"]'
    element :migrate_from_syn_list, 'select[id$="ddlSynonymLists"]'
    element :migrate, 'a[id$="upSynACG_upgradeBtn"]'
    element :migration_started_message, 'table[class="HeaderTable"]'
    element :synonym_table_row, 'table[id$="gridElements_DXMainTable"] > tbody > tr'
    element :reconcile_link, 'a[title*="Reconcile this synonym list"]'
    element :upgrade_synonym_list_link, 'a[title*="Upgrade this synonym list"]'
    element :expand_suggestions, 'a[href*="massAccept=0"]'
    element :expand_options,  'img[alt="[Expand]"]'

    # @method: verifies that synonym page is loaded. Works as a synchronization point for synonym page.
    def verify_synonym_page_loaded
      raise 'Synonym page is not loaded' unless select_dictionary.visible?
    end

    # creates a synonym list once on the synonym page.
    # @param list_name [String]. Pass in the name of your synonym list you wish to create.
    # @param dictionary_name [String]. Dictionary to use for the synonym list.
    # @param dictionary_version [Float]. Dictionary version to be used for the synonym list.
    # @param locale [String]. By default it will try to use ENG as the dictionary locale unless 'JPN' is passed in.
    def create_and_start_synonym_list(list_name, dictionary_name, dictionary_version, locale = 'eng')
      select_dictionary.select dictionary_name
      select_locale.select locale
      select_dictionary_version.select dictionary_version
      add_new.click
      syn_name.set list_name
      save_synonym_list.click
      sleep 3
      if synonym_creation_message.text == /Synonym list created successfully./
      elsif
      synonym_creation_message.text == /Synonym list could not be created, dictionary version already has a list with same name./
         ## we should plan on removing these texts out of the methods and put them in a file and read from that file. Creating a Hash would be a good idea.
         raise "Error creating synonym list. #{synonym_creation_message.text}"
      end
      upgrade_synonym_list.click
      start_synonym_list.click
    end
    # creates a synonym list
    # @param list_name [String]. Pass in the name of your synonym list you wish to create.
    # @param dictionary_name [String]. Dictionary to use for the synonym list.
    # @param dictionary_version [Float]. Dictionary version to be used for the synonym list.
    # @param locale [String]. Possible values are 'eng' or 'jpn'. 
    def create_synonym_list(list_name, dictionary_name, dictionary_version, locale = 'eng')
      select_dictionary.select dictionary_name
      select_locale.select locale
      select_dictionary_version.select dictionary_version
      add_new.click
      syn_name.set list_name
      save_synonym_list.click
      sleep 3
    end

    # this method upgrades a synonym list
    # @param syn_list [String] see method 'create_and_start_synonym_list'
    # @param dict_name [String] see method 'create_and_start_synonym_list'
    # @param dict_version [Numeric] see method 'create_and_start_synonym_list'
    # @param from_syn_list [String] Synoym list to migrate from
    # @param from_dict [String] Dictionary version migrating from
    def syn_create_and_migrate(syn_list, dict_name, dict_version, from_syn_list, from_dict)
      create_and_start_synonym_list(syn_list, dict_name, dict_version)
      select_link_by_row_value(syn_list,'Upgrade Synonym List' )
      upgrade(from_dict, from_syn_list)
    end

    # this method upgrades a synonym list by waiting for 60 seconds to make sure the update synonym list link is available
    # @param version [Numeric] Dictionary version to upgrade from
    # @param syn_list [String] Synonym List to migrate from
    def upgrade(version, syn_list)
      wait_until_upgrade_synonym_list_link_visible(60)
      page.all('a', :text => 'Upgrade Synonym List').first.click
      migrate_from_version.select version
      migrate_from_syn_list.select syn_list
      migrate.click
    end

    # this method ensures that  a synonym list migration is complete by checking for the existence of a reconcil link
    # @param syn_list_to_activate [String] synonym list we are going to reconcile
    def verify_migration_complete(syn_list_to_activate)
      wait_until_reconcile_link_visible(600)
      found_value = false
      find('table[id$="dversions_DXMainTable"] > tbody').all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.downcase.strip
          if cell_data == syn_list_to_activate.downcase
             row.find_link('Reconcile Synonym Migration').click
            sleep 2
            found_value = true
          end
          break if found_value
        end
        break if found_value
      end
    end

    # this method performs a reconciliation for a synonym migration.
    # @param select_suggestion [String].  'first' is default if nothing is passed as parameter.
    def reconcile_by_accepting_suggestion(select_suggestion = 'first')
      expand_suggestions.click
      sleep 2
      expand_options.click
      sleep 2
      case select_suggestion
        when 'first'
          page.all('a', :text => 'Accept Suggestion')[1].click
        when 'second'
          page.all('a', :text => 'Accept Suggestion')[2].click
        when 'third'
          page.all('a', :text => 'Accept Suggestion')[3].click
        when 'any'
          page.all('a', :text => 'Accept Suggestion').first.click # select the first link
        else
          raise 'For now we handle up to selecting the 3rd suggestion. Please accept first or second or third suggetsion'
      end
      sleep 2
      page.find_link('Migrate Synonym').click
      sleep 5
      puts 'Synonym Migration Completed!'
    end

    private
    def select_link_by_row_value(row_text, link_text)
      found_value = false
      find('table[id$="dversions_DXMainTable"] > tbody').all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.downcase.strip
          if cell_data == row_text.downcase
            row.find_link(link_text).click
            sleep 5
            found_value = true
          end
          break if found_value
        end
        break if found_value
      end

    end

  end
end



