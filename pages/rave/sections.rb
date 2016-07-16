require_relative '../common/base_section'

module Rave
  class Header < Common::BaseSection

    element :logoutlink, 'a[id$=LogoutLink]'
    element :homelink, 'a[id$=HomeLink]'
    element :helplink, 'a[id$=HelpLink]'
    element :profilelink, 'a[id$=ProfileLink]'
    element :messageslink, 'a[id$=MessagesLink]'
    element :imedidatalink, 'a[id$=iMedidataLink]'

    # clicks the Rave logout link
    def logout
      self.logoutlink.click
    end

    # clicks the Rave homepage link
    def go_home
      self.homelink.click
    end

    # clicks the Rave help link
    def help
      self.helplink.click
    end

    # clicks the my profile link
    def profile
      self.profilelink.click
    end

    # clicks the messages link
    def messages
      self.messageslink.click
    end

    # clicks the iMedidata link
    def goto_imedidata
      self.imedidatalink.click
    end

  end

  class NavigationTabs < Common::BaseSection

    elements :tabs, 'a[id*="PgHeader_TabTextHyperlink"]'

    def select_study_tab(study_name)
      find_study_tab(study_name).click
    end

    def find_study_tab(study_name)
      study_tab = tabs.detect { |inner_item| inner_item.text == study_name }
      raise "Study #{study_name} not found on rave home page" unless study_tab
      study_tab
    end

    def all_tabs
      tabs
    end

  end

  # Subject Navigation Panel
  class SubjectMenuNav < Common::BaseSection

    element :menu_table, 'table[id$="LeftNav_EDCTaskList_TblTaskItems"]'
    elements :main_menu_items, 'table[id$="LeftNav_ModuleList_DisplayBox_DisplayGrid"] > tbody > tr > td > a'
    # Navigates through forms and folders
    # @param form_or_folder [string] name of folder or form to navigate to.
    def form_folder_navigate(form_or_folder)
      menu_item = menu_table.all(:css, 'a', :text => "#{form_or_folder}").first
      menu_item.click
    end
    # Navigates through Main Menu
    # @param main_menu_item [string] name of module to navigate to.
    # valid values: User Administration|Architect|Site Administration|Reporter|Configuration|Report Administration|Lab Administration|DDE|Translation Workbench|PDF Generator|DCF|Query Management|Welcome Message
    def main_menu_nav(main_menu_item)
        main_menu_items.each do |item|
          if item.text == main_menu_item
            item.click
            break
          end
        end
    end

    def open_form_by_name(form_name)
      page.find(:id, 'MasterLeftNav').click_link form_name
    end

  end
end