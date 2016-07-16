require_relative '../common/base_section'

module Ravex

  #Header
  class Header < Common::BaseSection

  end

  #Navigation
  class Navigation < Common::BaseSection

  end

  #Subject Header
  class SubjectHeader < Common::BaseSection

    element :subject_header, 'div[class="page-header-text"]'
    elements :buttons, 'a[class$="btn-default"]'

    # Gets the subject name from the Subject Header section.
    def get_subject_name
      subject_name = subject_header.text.sub! 'Subject:', ''
      subject_name = subject_name.strip!
      subject_name
    end

    # Clicks on the button to inactivate the form.
    def inactivate_form
      inactivate_page_btn = buttons.detect { |item| item.text == 'Inactivate Page' }
      if inactivate_page_btn
        inactivate_page_btn.click
      else
        raise 'Inactivate Page button is not available on the page.'
      end
    end

    # Clicks on the button to activate the form.
    def activate_form
      activate_page_btn = buttons.detect { |item| item.text == 'Activate Page' }
      if activate_page_btn
        activate_page_btn.click
      else
        raise 'Activate Page button is not available on the page.'
      end
    end
  end

  # Subject Navigation Panel
  class SubjectMenuNav < Common::BaseSection
    elements :menu_folders, 'a[class*="mcc-collapse-toggle"]'
    elements :menu_forms, 'a[class="crfLink "]'
    element :subject_header, '#left-rail > div > ul > li.active > a'

    # Navigates to specified form on Subject Navigation Panel
    # @param form_name [string] form name to open
    def navigate_to_form(form_name)
      form = menu_forms.find { |item| item.text == form_name }
      if form
        form.click
        sleep 1
      else
        raise "Form: #{form_name} is not available on the page."
      end
    end

    # Navigates to specified folder on Subject Navigation Panel
    # @param folder_name [string] folder name to open
    def navigate_to_folder(folder_name)
      folder = menu_folders.detect { |item| item.text == folder_name }
      if folder
        folder.click
        sleep 1
      else
        raise "Folder: #{folder_name} is not available on the page."
      end
    end

    # Gets the subject name from the Subject Navigation panel.
    def get_subject_name_from_nav_panel
      if subject_header
        subject_name = subject_header.text
        subject_name
      end

    end
  end

  #CRF Version section.
  class CrfVersion < Common::BaseSection

  end

  # Handles all forms a like using Pagination
  class Pagination < Common::BaseSection
    element :ten_per_page, 'a#per_page_10'
    element :twenty_five_per_page, 'a#per_page_25'
    element :fifty_per_page, 'a#per_page_50'
    element :hundred_per_page, 'a#per_page_100'
    element :total_pages, 'div[class="total-results"]'
    element :page_field, 'input#current-page'
    element :to_first_page, 'i[class="fa fa-angle-double-left"]'
    element :to_last_page, 'i[class="fa fa-angle-double-right"]'

    #Navigate to the first page
    def go_to_first_page
      to_first_page.click
    end

    #Navigate to the last page
    def go_to_last_page
      to_last_page.click
    end

    #Changes the number of items per page
    def change_number_items_per_page(number_per_page)
      case number_per_page.to_i
        when 10
          ten_per_page.click
        when 25
          twenty_five_per_page.click
        when 50
          fifty_per_page.click
        when 100
          hundred_per_page.click
        else
          raise "Number of items per page: #{number_per_page} is not supported."
      end
    end
  end

end