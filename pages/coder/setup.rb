require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class Setup < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :select_segment, 'select[id$= "ddlSegments"]'
    element :select_dictionary, 'select[id$= "ddlLocales"]'
    element :dictionary_to_roll_out, 'select[id$= "ddlDictionaryLocale"]'
    elements :pages, 'table[id$="Main_Theme"] > tbody > tr > td > table > tbody > tr > td'
    elements :table_bottom, 'table[id*="Versions_DXPagerBottom"] > tbody > tr > td > table > tbody'
    elements :license_table, 'table[id$="gridLicences"] > tbody'
    element :license_key, 'input[id*= "DXEditor0"]'
    element :license_start_date, 'input[id*= "DXEditor1"]'
    element :license_end_date, 'input[id*= "DXEditor2"]'
    #element :add_license, :xpath, "//*[@id='ctl00_Content_gridLicences_DXEditingRow']/td[5]/img[1]"
    element :add_license,  'table[id*="gridLicences_DXMainTable"] > tbody > tr > td > img[1]'
    elements :all_rows, 'table[id$=gridVersions_DXMainTable] > tbody > tr > td:nth-child(3)'
    elements :next_page, 'table[id$=DXPagerBottom] > tbody > tr > td > table > tbody > tr > td:nth-child(11)'
    element :add_new, '[id$=LnkAddNewgridLicences] > b > i'

    # this method rolls out a specific version of a dictionary once it's found
    # @param version [String] (though it's a floating number, it's treated as a string intentionally)
    def roll_out_version (version)
      found_value = false
      find('table[id$="gridVersions_DXMainTable"] > tbody').all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.strip
          if cell_data == version
            row.find_link('Roll Out Subscriptions').click
            sleep 5
            found_value = true
          end
          break if found_value
        end
        break if found_value
      end
      found_value
    end


    # this method is a helper method for roll_out_version method. This checks to see if the wishing version is on the first page or not
    # @param version [String] (though it's a floating number, it's treated as a string intentionally)
    def find_version(version)
      current_page = 1
      last_page = page_count
      version_found = false
      while current_page <= last_page
        version_found = roll_out_version version
         if version_found
           break
         else
           go_to_next_page unless page_count == 1
           current_page += 1
         end
      end
      raise "Version #{version} not found" unless version_found
    end

    # select a dictionary from the drop-down in order to roll out dictionary
    # @param dict_with_locale [String]
    def select_dictionary_to_roll_out(dict_with_locale)
      dictionary_to_roll_out.select dict_with_locale
    end

    # selects a segment only
    # @param seg_name[String]
    def select_seg(seg_name)
      select_segment.select seg_name
    end

    # selects a segment and a dictionary [for adding a license key if there is none]
    # @param seg_name[String], dict [String] (dictionary name only with locale)
    def select_seg_n_dict(seg_name, dict)
      select_segment.select seg_name
      select_dictionary.select dict
    end

    # selects dictionary for dictonary rollout
    # @param seg_name[String], dict [String] (dictionary name only with locale)
    def select_dict_to_rollout(dict)
      dictionary_to_roll_out.select dict
    end

    # add a license key with given value or sets its own values to add a license key
    # @param key [String], start_date [String], exp_data [String]
    def add_license(key, start_date, end_date)
      license_there = false
      if license_there == license_code_exists
      else
        add_new.click
        license_key.set key
        license_start_date.set start_date
        license_end_date.set end_date
        #add_license.click # this step has some serious funky issue thus clicking by xpath below
        find(:xpath, "//*[@id='ctl00_Content_gridLicences_DXEditingRow']/td[5]/img[1]").click
        sleep 3
      end
    end

    private

    # this same method is used to go to the next page from the coder admin console page to roll out dictionaries
    def go_to_next_page
      next_page[0].click
      puts 'I\'m on next page'
      sleep 5
    end

    # this method is used to count how many pages are there on the dictionary roll out table
    # @return: returns how many pages there are. Returns 1 if the element to count pages does not exist
    def page_count
      total_pages = 0
      if table_bottom.empty?
        total_pages = 1
      else
        table_bottom.detect do |row|
          cell =  row.all('tr')
          cell.each do |t|
            if t.text.match '1 of'
              row_text = t.text.split(/[\s]/)
              total_pages = row_text[3].strip
              break
            else
              puts 'Have not found the pages yet!'
            end
          end
        end
      end
      total_pages.to_i
    end

    # this method checks to see if there is a license key for a dictionary in a segment
    # @return returns true if there is no license key and false if the there is a license key
    def license_code_exists
      found_value = false
      find('table[id*="gridLicences_DXMainTable"] > tbody').all('tr').map do |row|
        row.all('td').map do |cell|
          if cell.text.strip.downcase.match 'no data'
            found_value = true
          elsif cell.text.strip == 'abc123' || cell.text.strip == '1/1/2000'
          end
          break if found_value
        end
        break if found_value
      end
      found_value
    end



  end
end
