require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class InventoryOverview < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :inventory_overview_table, Table, '#inventory_item_list'

    element :overview, '#view_types .btn:nth-child(1)'
    element :by_item, '#view_types .btn:nth-child(2)'


  end
end


