require_relative '../common/base_section'

module Coder
  class Navigation < Common::BaseSection

    element :admin_menu, 'a[id$="navMenuLink"]'
    element :browser_tab, 'a[id$="browserLink"]'
    element :tasks_tab, 'a[id$="taskLink"]'


    # following method is used to navigate to coder admin pages
    # @param page_name [String] string needs to match with method expectation
    # to use it pass is the page name as described in the when cases or else the method will not work
    def navigate_to_page(page_name)
      # need to come up with a way to add all the page verification
      admin_menu.click
      page_link = page.find_link(page_name)
      raise "Couldn't find page #{page} in admin menu" unless page_link
      page_link.click
    end

    def select_tab(tab)
      case tab
        when 'browser'
          browser_tab.click
          sleep 3
        when 'tasks'
          tasks_tab.cick
      end
    end

  end

  class Header < Common::BaseSection
    element :go_to_iMedidata, '#ctl00_PgHeader_LnkIMedidata > b > span > u'
    element :coder_help, 'a[id$="HlpControl_HelpLink"]'
    element :coder_logout, 'a[id$="LogoutLink"]'
    element :coder_logo, 'img[id$="Logo"]'

    def switch_to_imedidata
      go_to_iMedidata.click
      sleep 2
    end
  end

  class Footer < Common::BaseSection
    element :medidata_solutions, 'a[id$="medidataURL"]'
    element :coder_build_number, 'span[id$="buildNumber"]'
  end

end
