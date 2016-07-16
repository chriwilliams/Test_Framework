require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class ManageDepots < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :depots_table, Table, '#depot_list'


  end
end

